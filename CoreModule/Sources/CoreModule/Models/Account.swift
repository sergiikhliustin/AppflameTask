import Foundation

struct Account: Identifiable, Equatable, Hashable {
    let id: Int
    let date: Date
    let accountName: String
    let description: String
    let amount: Double
}
