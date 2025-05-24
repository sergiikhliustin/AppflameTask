import Foundation
import SwiftUI

extension Color {
    static let cFFFFFF: Color = .hex("#FFFFFF")
    static let cFFFFFF_24: Color = .hex("#FFFFFF3D")
    static let c171717: Color = .hex("#171717")
    static let c171717_60: Color = .hex("#17171799")
    static let cD2D2D2: Color = .hex("#D2D2D2")
    static let c171717_12: Color = .hex("#1717171E")
    static let c000000: Color = .hex("#000000")
    static let c171717_8: Color = .hex("#17171714")
    static let cFFFFFF_60: Color = .hex("#FFFFFF99")
    static let c0CE495: Color = .hex("#0CE495")
    static let c0CE495_16: Color = .hex("#0CE49528")
    static let c333333: Color = .hex("#333333")
    static let cA6A6A6_70: Color = .hex("#A6A6A6B2")
    static let c000000_17: Color = .hex("#0000002B")
    static let c062818: Color = .hex("#062818")
    static let cC0FF43_6: Color = .hex("#C0FF430F")
    static let cFFA743_16: Color = .hex("#FFA74328")
    static let cFFF643_5: Color = .hex("#FFF6430C")
    static let cFFFFFF_15: Color = .hex("#FFFFFF26")
    static let c0F6445: Color = .hex("#0F6445")
    static let cE7E7E7: Color = .hex("#E7E7E7")
    static let c1ABE26: Color = .hex("#1ABE26")
}

extension Color {
    static func hex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r, g, b, a: Double
        switch hexSanitized.count {
        case 6: // RRGGBB
            (r, g, b, a) = (
                Double((rgb & 0xFF0000) >> 16) / 255,
                Double((rgb & 0x00FF00) >> 8) / 255,
                Double(rgb & 0x0000FF) / 255,
                1.0
            )
        case 8: // RRGGBBAA
            (r, g, b, a) = (
                Double((rgb & 0xFF000000) >> 24) / 255,
                Double((rgb & 0x00FF0000) >> 16) / 255,
                Double((rgb & 0x0000FF00) >> 8) / 255,
                Double(rgb & 0x000000FF) / 255
            )
        default:
            return .clear
        }

        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
