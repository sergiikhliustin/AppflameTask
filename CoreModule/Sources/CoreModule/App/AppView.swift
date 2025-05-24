import Foundation
import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            StatisticsView(store: store.scope(state: \.statistics, action: \.statistics))
        } destination: { store in
            Group {
                switch store.case {
                case .accountDetails(let accountDetailsStore):
                    AccountDetailsView(store: accountDetailsStore)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
