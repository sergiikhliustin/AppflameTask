import Foundation
import ComposableArchitecture

struct ChartDataItem: Identifiable {
    var id: Date {
        return date
    }
    let date: Date
    let value: Double
}

@Reducer
struct ChartFeature {
    @ObservableState
    struct State {
        let accounts: [Account]
        var chartData: [ChartDataItem]
        let minY: Double
        let maxY: Double
        var selectedAccount: Account? = nil
        var selectedDate: Date? = nil
        init(accounts: [Account]) {
            self.accounts = accounts
            self.minY = accounts.map { $0.amount }.min() ?? 0
            self.maxY = accounts.map { $0.amount }.max() ?? 0
            self.chartData = accounts.map { account in
                return ChartDataItem(
                    date: account.date,
                    value: account.amount
                )
            }
        }
    }

    enum Action {
        case onDateSelected(Date?)
        case onAccountSelected(Account?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onDateSelected(let date):
                guard let date else {
                    return .none
                }
                let selectedAccount = state
                    .accounts
                    .min(by: {
                        abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
                    })
                state.selectedAccount = selectedAccount
                state.selectedDate = selectedAccount?.date
                return .run { send in
                    await send(.onAccountSelected(selectedAccount))
                }
            case .onAccountSelected:
                return .none
            }
        }
    }
}
