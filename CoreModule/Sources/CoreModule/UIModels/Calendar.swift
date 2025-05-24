import Foundation

extension Calendar {
    static var shared: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = .gmt
        return calendar
    }
}
