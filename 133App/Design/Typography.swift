//
//  Typography.swift
//  133App
//
//  133 앱의 타이포그래피 시스템
//  Figma 디자인 가이드 기반
//

import SwiftUI

// MARK: - Font Extensions

extension Font {
    // MARK: - Display

    /// Display/Large - 화면 타이틀 (28pt, Bold)
    static let displayLarge = Font.system(size: 28, weight: .bold, design: .default)

    // MARK: - Heading

    /// Heading/Large - 섹션 제목 (24pt, Bold)
    static let headingLarge = Font.system(size: 24, weight: .bold, design: .default)

    /// Heading/Medium (22pt, SemiBold)
    static let headingMedium = Font.system(size: 22, weight: .semibold, design: .default)

    /// Heading/Small (18pt, SemiBold)
    static let headingSmall = Font.system(size: 18, weight: .semibold, design: .default)

    // MARK: - Body

    /// Body/Large (17pt, SemiBold)
    static let bodyLarge = Font.system(size: 17, weight: .semibold, design: .default)

    /// Body/Regular (16pt, Regular)
    static let bodyRegular = Font.system(size: 16, weight: .regular, design: .default)

    /// Body/Small (15pt, Medium)
    static let bodySmall = Font.system(size: 15, weight: .medium, design: .default)

    // MARK: - Caption

    /// Caption (14pt, Medium)
    static let caption = Font.system(size: 14, weight: .medium, design: .default)

    /// Caption/Small (13pt, Medium)
    static let captionSmall = Font.system(size: 13, weight: .medium, design: .default)

    // MARK: - Button

    /// Button Text (16pt, SemiBold)
    static let buttonText = Font.system(size: 16, weight: .semibold, design: .default)

    // MARK: - Timer

    /// Timer Number (72pt, Bold, Rounded)
    static let timerLarge = Font.system(size: 72, weight: .bold, design: .rounded)
        .monospacedDigit()

    /// Timer Unit (24pt, Medium)
    static let timerUnit = Font.system(size: 24, weight: .medium, design: .rounded)

    // MARK: - Stats

    /// Stats Value (32pt, Bold)
    static let statsValue = Font.system(size: 32, weight: .bold, design: .default)
        .monospacedDigit()
}

// MARK: - Text Style Modifiers

struct TextStyleModifier: ViewModifier {
    let style: TextStyle

    enum TextStyle {
        case displayLarge
        case headingLarge
        case headingMedium
        case headingSmall
        case bodyLarge
        case bodyRegular
        case bodySmall
        case caption
        case captionSmall
        case buttonText
        case timerLarge
        case statsValue

        var font: Font {
            switch self {
            case .displayLarge: return .displayLarge
            case .headingLarge: return .headingLarge
            case .headingMedium: return .headingMedium
            case .headingSmall: return .headingSmall
            case .bodyLarge: return .bodyLarge
            case .bodyRegular: return .bodyRegular
            case .bodySmall: return .bodySmall
            case .caption: return .caption
            case .captionSmall: return .captionSmall
            case .buttonText: return .buttonText
            case .timerLarge: return .timerLarge
            case .statsValue: return .statsValue
            }
        }

        var lineSpacing: CGFloat {
            switch self {
            case .displayLarge: return 8
            case .headingLarge: return 8
            case .headingMedium: return 8
            case .headingSmall: return 8
            case .bodyLarge: return 7
            case .bodyRegular: return 6
            case .bodySmall: return 6
            case .caption: return 6
            case .captionSmall: return 5
            case .buttonText: return 6
            case .timerLarge: return 0
            case .statsValue: return 0
            }
        }

        var tracking: CGFloat {
            switch self {
            case .displayLarge, .headingLarge, .headingMedium: return -0.5
            case .headingSmall, .bodyLarge, .bodyRegular, .bodySmall: return -0.3
            case .caption, .captionSmall, .buttonText: return 0
            case .timerLarge, .statsValue: return -1
            }
        }

        var defaultColor: Color {
            switch self {
            case .displayLarge, .headingLarge, .headingMedium, .headingSmall, .bodyLarge, .bodyRegular:
                return .adaptiveText
            case .bodySmall, .caption, .captionSmall:
                return .adaptiveSecondaryText
            case .buttonText:
                return .white
            case .timerLarge, .statsValue:
                return .adaptiveText
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .tracking(style.tracking)
            .foregroundColor(style.defaultColor)
    }
}

extension View {
    func textStyle(_ style: TextStyleModifier.TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}
