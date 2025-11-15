//
//  AppInfoView.swift
//  133App
//
//  앱 정보 화면
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss) private var dismiss

    // 앱 정보
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.adaptiveBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.xl) {
                        // App Icon & Name
                        VStack(spacing: Spacing.lg) {
                            // App Icon
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [.softPeach, .gentleLavender],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Text("133")
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: Color.softPeach.opacity(0.3), radius: 20, y: 10)

                            // App Name
                            Text("133")
                                .textStyle(.displayLarge)

                            // Tagline
                            Text("하루 3분, 3개만 하자")
                                .textStyle(.bodyLarge)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                        .padding(.top, Spacing.xl)

                        // Version Info Card
                        VStack(spacing: 0) {
                            InfoRow(label: "버전", value: appVersion)
                            Divider()
                                .background(Color.adaptiveDivider)
                            InfoRow(label: "빌드", value: buildNumber)
                        }
                        .background(Color.adaptiveCardBackground)
                        .largeRadius()
                        .lightShadow()

                        // Description Card
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("About")
                                .textStyle(.headingSmall)
                                .foregroundColor(.adaptiveText)

                            Text("133은 미니멀리스트를 위한 할 일 관리 앱입니다.\n\n하루에 딱 3개의 작은 일만 집중하세요. 3분이면 충분합니다.\n\n못해도 괜찮아요. 1개만 해도 당신은 오늘 어제와 달라요.")
                                .textStyle(.bodyRegular)
                                .foregroundColor(.adaptiveSecondaryText)
                                .lineSpacing(6)
                        }
                        .padding(Spacing.cardInternalLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.adaptiveCardBackground)
                        .largeRadius()
                        .lightShadow()

                        // Features Card
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            Text("주요 기능")
                                .textStyle(.headingSmall)
                                .foregroundColor(.adaptiveText)

                            FeatureRow(icon: "checkmark.circle.fill", title: "하루 최대 3개", description: "집중력을 위한 제한")
                            FeatureRow(icon: "timer", title: "집중 타이머", description: "몰입을 도와주는 타이머")
                            FeatureRow(icon: "chart.bar.fill", title: "실천 통계", description: "성장을 확인하세요")
                            FeatureRow(icon: "moon.fill", title: "다크 모드", description: "눈이 편안한 테마")
                        }
                        .padding(Spacing.cardInternalLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.adaptiveCardBackground)
                        .largeRadius()
                        .lightShadow()

                        // Developer Info
                        VStack(spacing: Spacing.sm) {
                            Text("Made with ❤️")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)

                            Text("© 2025 윤프로")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveTertiaryText)
                        }
                        .padding(.vertical, Spacing.xl)

                        Spacer(minLength: Spacing.screenBottom)
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
            }
            .navigationTitle("앱 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                    .foregroundColor(.softPeach)
                }
            }
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .textStyle(.bodyLarge)
                .foregroundColor(.adaptiveSecondaryText)

            Spacer()

            Text(value)
                .textStyle(.bodyLarge)
                .foregroundColor(.adaptiveText)
                .fontWeight(.semibold)
        }
        .padding(Spacing.cardInternal)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.softPeach)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .textStyle(.bodyLarge)
                    .foregroundColor(.adaptiveText)

                Text(description)
                    .textStyle(.captionSmall)
                    .foregroundColor(.adaptiveSecondaryText)
            }

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    AppInfoView()
}
