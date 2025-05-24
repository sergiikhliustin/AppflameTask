import SwiftUI

struct TimeRangeSelector: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(TimeRange.allCases) { range in
                Button {
                    self.selectedRange = range
                } label: {
                    Text(range.rawValue)
                        .typography(.sfProSemibold14)
                        .foregroundStyle(Color.cFFFFFF)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(range == selectedRange ? Color.cFFFFFF_15 : Color.clear)
                        )
                }
            }
        }
    }
} 
