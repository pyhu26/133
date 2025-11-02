//
//  Shadows.swift
//  133App
//
//  133 앱의 그림자 시스템
//  Figma 디자인 가이드 기반
//

import SwiftUI

// MARK: - Shadow Extensions

extension View {
    /// Light Shadow - 카드 기본 (Y: 2px, Blur: 8px, 4% opacity)
    func lightShadow() -> some View {
        self.shadow(
            color: Color.deepWarmGray.opacity(0.04),
            radius: 4,
            x: 0,
            y: 2
        )
    }

    /// Medium Shadow - 카드 hover (Y: 4px, Blur: 16px, 8% opacity)
    func mediumShadow() -> some View {
        self.shadow(
            color: Color.deepWarmGray.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    /// Strong Shadow - 강조 (Y: 8px, Blur: 24px, 12% opacity)
    func strongShadow() -> some View {
        self.shadow(
            color: Color.deepWarmGray.opacity(0.12),
            radius: 12,
            x: 0,
            y: 8
        )
    }

    /// Accent Shadow - CTA 버튼 (Y: 4px, Blur: 16px, 30% opacity)
    func accentShadow() -> some View {
        self.shadow(
            color: Color.softPeach.opacity(0.30),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

// MARK: - Border Radius

extension View {
    /// Small Border Radius - 아이콘 박스, 토글 (12px)
    func smallRadius() -> some View {
        self.cornerRadius(12)
    }

    /// Medium Border Radius - 버튼, 입력 필드 (16px)
    func mediumRadius() -> some View {
        self.cornerRadius(16)
    }

    /// Large Border Radius - 카드 (20px)
    func largeRadius() -> some View {
        self.cornerRadius(20)
    }

    /// XLarge Border Radius - 메인 카드, Bottom Sheet (24px)
    func xLargeRadius() -> some View {
        self.cornerRadius(24)
    }

    /// Circle Border Radius
    func circleRadius() -> some View {
        self.clipShape(Circle())
    }
}

// MARK: - Spacing

struct Spacing {
    /// Base Unit: 8pt
    static let baseUnit: CGFloat = 8

    /// 8pt
    static let xs: CGFloat = 8

    /// 12pt
    static let sm: CGFloat = 12

    /// 16pt
    static let md: CGFloat = 16

    /// 20pt
    static let lg: CGFloat = 20

    /// 24pt
    static let xl: CGFloat = 24

    /// 32pt
    static let xxl: CGFloat = 32

    /// 40pt
    static let xxxl: CGFloat = 40

    // MARK: - Screen Padding

    /// Screen Horizontal Padding: 24px
    static let screenHorizontal: CGFloat = 24

    /// Screen Top Padding: 20px
    static let screenTop: CGFloat = 20

    /// Screen Bottom Padding: 40px
    static let screenBottom: CGFloat = 40

    // MARK: - Card Padding

    /// Card Internal Padding: 20px
    static let cardInternal: CGFloat = 20

    /// Card Internal Padding Large: 28px
    static let cardInternalLarge: CGFloat = 28

    // MARK: - Safe Area

    /// Status Bar Height: 44pt
    static let statusBarHeight: CGFloat = 44

    /// Tab Bar Height: 49pt (iPhone), 65pt (iPhone with notch)
    static let tabBarHeight: CGFloat = 49
}
