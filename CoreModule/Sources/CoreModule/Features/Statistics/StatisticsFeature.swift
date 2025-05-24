import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct StatisticsFeature {
    @ObservableState
    struct State {
        var data: DataState<[Account]> = .loading
        var chart: ChartFeature.State = ChartFeature.State(accounts: [])
        var accountList: AccountListFeature.State = AccountListFeature.State(accounts: [])
        var timeRange: TimeRange = .month
        var accountsData: AccountsData = AccountsData.empty()
        var selectedAccount: Account? = nil
    }

    enum Action {
        case loadData
        case dataLoaded(Result<[Account], Error>)
        case chart(ChartFeature.Action)
        case accountList(AccountListFeature.Action)
        case delegate(Delegate)
        case timeRangeChanged(TimeRange)
        case onClearSelectedAccount

        enum Delegate {
            case onAccount(Account)
        }
    }

    @Dependency(\.dataService) var dataService

    var body: some ReducerOf<Self> {
        Scope(state: \.chart, action: \.chart) {
            ChartFeature()
        }
        Scope(state: \.accountList, action: \.accountList) {
            AccountListFeature()
        }
        Reduce { state, action in
            switch action {
            case .loadData:
                state.data = .loading
                return .run { [dataService = self.dataService] send in
                    await send(
                        .dataLoaded(
                            Result { try await dataService.loadAccounts() }
                        )
                    )
                }
            case .dataLoaded(.success(let accounts)):
                state.data = .loaded(accounts)
                reloadAccountsData(state: &state)
                return .none

            case .dataLoaded(.failure):
                state.data = .error("Failed to load transactions.")
                return .none
            case .delegate:
                return .none
            case .accountList(.onAccount(let account)):
                return .send(
                    .delegate(.onAccount(account))
                )
            case .accountList:
                return .none
            case .timeRangeChanged(let timeRange):
                state.timeRange = timeRange
                reloadAccountsData(state: &state)
                return .none
            case .chart(.onAccountSelected(let account)):
                state.selectedAccount = account
                return .run { send in
                    await send(
                        .accountList(.onAccountSelected(account))
                    )
                }
            case .chart:
                return .none
            case .onClearSelectedAccount:
                state.selectedAccount = nil
                state.chart = ChartFeature.State(accounts: state.accountsData.accounts)
                state.accountList = AccountListFeature.State(accounts: state.accountsData.accounts)
                return .none
            }
        }
    }

    private func reloadAccountsData(state: inout State) {
        guard case .loaded(let accounts) = state.data else { return }
        do {
            let accountsData = try dataService.accountsData(accounts, timeRange: state.timeRange)
            state.accountsData = accountsData
            state.chart = ChartFeature.State(accounts: accountsData.accounts)
            state.accountList = AccountListFeature.State(accounts: accountsData.accounts)
            state.selectedAccount = nil
        } catch {
            state.data = .error("Failed to load accounts.")
        }
    }
}
