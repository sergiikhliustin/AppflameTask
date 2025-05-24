import Foundation
import SwiftUI

struct DraggableBottomSheet<Content: View>: View {
    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentHeight: CGFloat = 0

    let minRatio: CGFloat
    let maxRatio: CGFloat
    let content: () -> Content

    init(minRatio: CGFloat = 0.5, maxRatio: CGFloat = 0.8, @ViewBuilder content: @escaping () -> Content) {
        self.minRatio = minRatio
        self.maxRatio = maxRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            let parentHeight = geo.size.height
            let minHeight = parentHeight * minRatio
            let maxHeight = parentHeight * maxRatio

            VStack {
                Spacer()

                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 54, height: 4)
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(.vertical, 8)

                    content()
                        .padding(.bottom, 20)
                }
                .frame(height: {
                    let proposed = currentHeight + dragOffset
                    return max(minHeight, min(proposed, maxHeight))
                }())
                .frame(maxWidth: .infinity)
                .background(Color.cFFFFFF)
                .cornerRadius(32)
                .shadow(radius: 8)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = -value.translation.height
                        }
                        .onEnded { value in
                            let offset = -value.translation.height
                            let projected = currentHeight + offset
                            let midpoint = (minHeight + maxHeight) / 2

                            withAnimation(.spring()) {
                                if projected > midpoint {
                                    currentHeight = maxHeight
                                } else {
                                    currentHeight = minHeight
                                }
                            }
                        }
                )
                .animation(.interactiveSpring(), value: dragOffset)
                .onAppear {
                    currentHeight = minHeight
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
