import Foundation
import SwiftUI
import ComposableArchitecture

struct StatisticsView: View {
    @Bindable var store: StoreOf<StatisticsFeature>

    var body: some View {
        VStack {
            switch store.data {
            case .loading:
                ProgressView("Loading...")
                    .padding()
            case .error(let error):
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            case .loaded:
                ZStack {
                    VStack(spacing: 0) {
                        Text("Statistics")
                            .typography(.sfProTextSemibold17)
                            .foregroundStyle(Color.cFFFFFF)
                            .padding(.top, 14)
                            .padding(.bottom, 13)
                        VStack(spacing: 4) {
                            Text((store.selectedAccount?.amount ?? store.accountsData.summary).formatStatisticsSummary())
                            Text(store.selectedAccount?.date.formattedFullDate() ?? store.accountsData.dateString)
                                .foregroundStyle(Color.cFFFFFF_60)
                                .typography(.sfProRegular13)
                        }

                        ChartView(store: store.scope(state: \.chart, action: \.chart))
                            .padding(.top, 32)
                            .padding(.bottom, 24)
                        TimeRangeSelector(selectedRange: $store.timeRange.sending(\.timeRangeChanged))
                        Spacer()
                    }
                    .background(Color.c062818)
                    .onTapGesture {
                        store.send(.onClearSelectedAccount)
                    }

                    DraggableBottomSheet(minRatio: 0.4, maxRatio: 0.9) {
                        AccountListView(store: store.scope(state: \.accountList, action: \.accountList))
                    }
                }
            }
        }
        .task {
            store.send(.loadData)
        }
    }
}

private extension Double {
    func formatStatisticsSummary() -> AttributedString {
        var attributedString = AttributedString(self.currencyFormatted())
        attributedString.foregroundColor = .cFFFFFF
        attributedString.font = Typography.sfProDisplayRegular48.font
        if let range = attributedString.range(of: "-") {
            attributedString[range].foregroundColor = .cFFFFFF_60
        }
        if let range = attributedString.range(of: "$") {
            attributedString[range].foregroundColor = .cFFFFFF_60
        }
        if let range = attributedString.range(of: ".") {
            attributedString[range.lowerBound...].font = Typography.sfProDisplayRegular24.font
        }
        return attributedString
    }
}
