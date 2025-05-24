import Foundation
import SwiftUI
import ComposableArchitecture
import Charts

struct ChartView: View {
    @Bindable var store: StoreOf<ChartFeature>
    private let chartPadding: Double = 16

    var body: some View {
        Chart(store.chartData) { item in
            AreaMark(
                x: .value("Date", item.date),
                yStart: .value("Start", store.minY),
                yEnd: .value("Value", item.value),
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.c0CE495_16,
                        Color.clear,
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            if let selectedAccount = store.selectedAccount {
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value),
                    series: .value("Segment", "A")
                )
                .foregroundStyle(Color.c0CE495)
                .interpolationMethod(.catmullRom)
                .mask {
                    RectangleMark(
                        xStart: .value("Mask Start", store.chartData.first?.date ?? Date()),
                        xEnd: .value("Mask End", selectedAccount.date),
                        yStart: .value("Min", store.minY),
                        yEnd: .value("Max", store.maxY)
                    )
                }
                .zIndex(1)
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value),
                    series: .value("Segment", "B")
                )
                .foregroundStyle(Color.c0F6445)
                .interpolationMethod(.catmullRom)
                .mask {
                    RectangleMark(
                        xStart: .value("Mask Start", selectedAccount.date),
                        xEnd: .value("Mask End", store.chartData.last?.date ?? Date()),
                        yStart: .value("Min", store.minY),
                        yEnd: .value("Max", store.maxY)
                    )
                }
                .zIndex(1)
            } else {
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.c0CE495)
            }

            if let selectedAccount = store.selectedAccount, selectedAccount.date == item.date {
                RuleMark(
                    x: .value("Selected", selectedAccount.date),
                    yStart: .value("Start", item.value),
                    yEnd: .value("End", store.minY)
                )
                .foregroundStyle(Color.cFFFFFF)
                .lineStyle(StrokeStyle(lineWidth: 2))

                PointMark(
                    x: .value("Selected Date", selectedAccount.date),
                    y: .value("Selected Value", selectedAccount.amount)
                )
                .foregroundStyle(Color.c0CE495)
                .symbolSize(64)
            }
        }
        .chartYScale(range: .plotDimension(padding: 20))
        .chartLegend(.hidden)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: store.chartData.map { $0.date }) { axisValue in
//                if let selectedAccount = store.selectedAccount,
//                    selectedAccount.date == store.chartData[axisValue.index].date
//                {
//                    AxisTick(
//                        centered: true,
//                        length: 28,
//                        stroke: StrokeStyle(lineWidth: 2)
//                    )
//                    .foregroundStyle(Color.cFFFFFF)
//                } else {
                    AxisTick(
                        centered: true,
                        length: 8,
                        stroke: StrokeStyle(lineWidth: 2)
                    )
                    .foregroundStyle(Color.cFFFFFF_24)
            }
        }
        .chartXSelection(value: $store.selectedDate.sending(\.onDateSelected))
        .frame(height: 170)
    }
}
