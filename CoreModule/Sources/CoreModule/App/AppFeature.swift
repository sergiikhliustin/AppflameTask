import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @Reducer
    enum Path {
        case accountDetails(AccountDetailsFeature)
    }
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var statistics = StatisticsFeature.State()
    }

    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case statistics(StatisticsFeature.Action)
    }

    @Dependency(\.dataService) var dataService

    var body: some ReducerOf<Self> {
        Scope(
            state: \.statistics,
            action: \.statistics
        ) {
            StatisticsFeature()
        }

        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case .statistics(.delegate(.onAccount(let account))):
                state.path.append(
                    .accountDetails(
                        AccountDetailsFeature.State(account: account)
                    )
                )
                return .none
            case .statistics:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
