//
//  Colors.swift
//  133App
//
//  133 앱의 컬러 시스템
//  Figma 디자인 가이드 기반
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors

    /// 주요 액센트, CTA 버튼 (#FFB5A7)
    static let softPeach = Color(hex: "FFB5A7")

    /// 배경, 카드 보조 (#F5E6D3)
    static let warmBeige = Color(hex: "F5E6D3")

    /// 메인 배경 (#F9F7F4)
    static let lightWarmGray = Color(hex: "F9F7F4")

    // MARK: - Supporting Colors

    /// 완료 상태 (#D4C5F9)
    static let gentleLavender = Color(hex: "D4C5F9")

    /// 진행 상태 (#C7F0DB)
    static let softMint = Color(hex: "C7F0DB")

    /// 정보 표시 (#C7E9F5)
    static let powderBlue = Color(hex: "C7E9F5")

    // MARK: - Neutral Colors

    /// 주요 텍스트 (#4A4238)
    static let deepWarmGray = Color(hex: "4A4238")

    /// 보조 텍스트 (#9B8F82)
    static let mediumGray = Color(hex: "9B8F82")

    /// 비활성/플레이스홀더 (#C5B9AC)
    static let lightGray = Color(hex: "C5B9AC")

    /// 테두리 (#E0D5C7)
    static let borderGray = Color(hex: "E0D5C7")

    // MARK: - Gradients

    /// Peach Gradient (135°)
    static let peachGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "FFB5A7"),
            Color(hex: "FFC4B8")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Card Accent Gradient (180°)
    static let cardAccentGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "FFB5A7"),
            Color(hex: "FFD3B6")
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    /// Lavender Gradient (배경, 135°)
    static let lavenderGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(hex: "FFB5A7"), location: 0.0),
            .init(color: Color(hex: "FFC4B8"), location: 0.5),
            .init(color: Color(hex: "D4C5F9"), location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Semantic Colors

    /// 성공 (#A8D5BA)
    static let success = Color(hex: "A8D5BA")

    /// 주의 (#FFD3B6)
    static let caution = Color(hex: "FFD3B6")

    /// 정보 (#C7E9F5)
    static let info = Color(hex: "C7E9F5")

    // MARK: - Helper

    /// Hex 문자열로부터 Color 생성
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
