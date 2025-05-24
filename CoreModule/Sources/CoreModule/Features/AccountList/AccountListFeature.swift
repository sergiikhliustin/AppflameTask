import Foundation
import ComposableArchitecture

@Reducer
struct AccountListFeature {
    @ObservableState
    struct State {
        let accounts: [Account]
        var filteredAccounts: [Account]? = nil
    }

    enum Action {
        case onAccount(Account)
        case onAccountSelected(Account?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAccountSelected(let account):
                if let date = account?.date {
                    state.filteredAccounts = state.accounts.filter { $0.date == date }
                } else {
                    state.filteredAccounts = nil
                }
                return .none
            case .onAccount:
                return .none
            }
        }
    }
}
