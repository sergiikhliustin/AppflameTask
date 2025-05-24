import Foundation
import SwiftUI
import CoreText

enum Typography {
    case sfProMedium16
    case sfProRegular13
    case sfProRegular16
    case sfProSemibold14
    case sfProTextSemibold17
    case sfProDisplayRegular48
    case sfProDisplayRegular40
    case sfProDisplayRegular24
    case urbanistSemibold20
    case urbanistMedium24

    var fontName: String {
        switch self {
        case .sfProMedium16: return "SF Pro Medium"
        case .sfProRegular13: return "SF Pro Regular"
        case .sfProRegular16: return "SF Pro Regular"
        case .sfProSemibold14: return "SF Pro Semibold"
        case .sfProTextSemibold17: return "SF Pro Text Semibold"
        case .sfProDisplayRegular48: return "SF Pro Display Regular"
        case .sfProDisplayRegular40: return "SF Pro Display Regular"
        case .sfProDisplayRegular24: return "SF Pro Display Regular"
        case .urbanistSemibold20: return "Urbanist-SemiBold"
        case .urbanistMedium24: return "Urbanist-Medium"
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .sfProMedium16: return 16
        case .sfProRegular13: return 13
        case .sfProRegular16: return 16
        case .sfProSemibold14: return 14
        case .sfProTextSemibold17: return 17
        case .sfProDisplayRegular48: return 48
        case .sfProDisplayRegular40: return 40
        case .sfProDisplayRegular24: return 24
        case .urbanistSemibold20: return 20
        case .urbanistMedium24: return 24
        }
    }

    var font: Font {
        .custom(fontName, size: fontSize)
    }
}

@MainActor
extension Text {
    func typography(_ typography: Typography) -> some View {
        registerFonts()
        return self.font(typography.font)
    }
}

@MainActor
extension View {
    func typography(_ typography: Typography) -> some View {
        registerFonts()
        return self.font(typography.font)
    }
}

@MainActor private var isFontsRegistered = false

@MainActor
private func registerFonts() {
    guard !isFontsRegistered else { return }
    let fonts = [
        ("SF-Pro", "ttf"),
        ("SF-Pro-Display-Regular", "otf"),
        ("SF-Pro-Text-Semibold", "otf"),
        ("Urbanist-Medium", "ttf"),
        ("Urbanist-SemiBold", "ttf"),
    ]

    for font in fonts {
        guard let url = Bundle.module.url(forResource: font.0, withExtension: font.1) else {
            print("Font file not found: \(font.0).\(font.1)")
            continue
        }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    isFontsRegistered = true
}
