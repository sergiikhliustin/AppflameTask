import SwiftUI
import ComposableArchitecture

public struct EntryPoint: View {
    let store: StoreOf<AppFeature>

    public init() {
        self.store = Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    }

    public var body: some View {
        AppView(store: store)
    }
}

#Preview {
    EntryPoint()
}
