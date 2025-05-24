import Foundation

struct AccountsData {
    let accounts: [Account]
    let summary: Double
    let dateString: String

    static func empty() -> AccountsData {
        AccountsData(
            accounts: [],
            summary: 0,
            dateString: ""
        )
    }
}
