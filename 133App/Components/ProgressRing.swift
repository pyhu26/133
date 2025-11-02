//
//  ProgressRing.swift
//  133App
//
//  타이머용 프로그레스 링 컴포넌트
//

import SwiftUI

struct ProgressRing: View {
    let progress: Double // 0.0 ~ 1.0
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: lineWidth
                )

            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.lavenderGradient
            .ignoresSafeArea()

        VStack(spacing: 40) {
            ProgressRing(progress: 0.25, size: 280, lineWidth: 12)
            ProgressRing(progress: 0.5, size: 200, lineWidth: 10)
            ProgressRing(progress: 0.75, size: 120, lineWidth: 8)
        }
    }
}
