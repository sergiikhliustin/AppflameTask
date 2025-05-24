import Foundation
import ComposableArchitecture

enum DataError: Error {
    case fileNotFound
    case dataParsingFailed
    case accountsDataError
}

@DependencyClient
struct DataService {
    func loadAccounts() async throws    (DataError) -> [Account] {
        guard let fileURL = Bundle.module.url(forResource: "data", withExtension: "csv") else {
            throw DataError.fileNotFound
        }
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw DataError.fileNotFound
        }
        guard let content = String(data: data, encoding: .utf8) else {
            throw DataError.dataParsingFailed
        }

        var lines = content.components(separatedBy: .newlines)

        guard lines.count > 1 else {
            throw DataError.dataParsingFailed
        }

        lines.removeFirst()

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.shared
        dateFormatter.timeZone = TimeZone.gmt
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let result: [Account] =
            lines.compactMap { line in
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedLine.isEmpty { return nil }

                let components = trimmedLine.components(separatedBy: ",")
                guard components.count == 5,
                    let id = Int(components[0]),
                    let date = dateFormatter.date(from: components[1]),
                    let amount = Double(components[4])
                else {
                    return nil
                }

                return Account(
                    id: id,
                    date: date,
                    accountName: components[2],
                    description: components[3],
                    amount: amount
                )
            }
            .sorted { $0.date < $1.date }

        guard !result.isEmpty else {
            throw DataError.dataParsingFailed
        }
        return result
    }

    func accountsData(_ accounts: [Account], timeRange: TimeRange) throws(DataError) -> AccountsData {
        let calendar = Calendar.shared
        let endDate = accounts.max(by: { $0.date < $1.date })?.date ?? Date()

        let startDate: Date
        let dateFormatter = DateFormatter()

        switch timeRange {
        case .week:
            guard
                let weekStart = calendar.date(
                    from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: endDate)
                )
            else {
                throw .accountsDataError
            }
            startDate = weekStart
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"

        case .month:
            guard
                let monthStart = calendar.date(
                    from: calendar.dateComponents([.year, .month], from: endDate)
                )
            else {
                throw .accountsDataError
            }
            startDate = monthStart
            dateFormatter.dateFormat = "MMMM yyyy"

        case .year:
            guard
                let yearStart = calendar.date(
                    from: calendar.dateComponents([.year], from: endDate)
                )
            else {
                throw .accountsDataError
            }
            startDate = yearStart
            dateFormatter.dateFormat = "yyyy"
        }

        let result = accounts.filter {
            $0.date >= startDate && $0.date <= endDate
        }

        let dateString = dateFormatter.string(from: startDate)
        let summary = result
            .map { $0.amount }
            .reduce(0, +)

        return AccountsData(
            accounts: result,
            summary: summary,
            dateString: dateString
        )
    }
}

extension DependencyValues {
    var dataService: DataService {
        get { self[DataService.self] }
        set { self[DataService.self] = newValue }
    }
}

extension DataService: DependencyKey {
    static let liveValue = DataService()
}
