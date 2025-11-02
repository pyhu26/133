//
//  SettingsView.swift
//  133App
//
//  설정 화면
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var encouragementEnabled = true
    @State private var darkModeEnabled = false
    @State private var soundEnabled = true

    var body: some View {
        ZStack {
            // Background
            Color.lightWarmGray
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Header
                    Text("설정")
                        .textStyle(.displayLarge)
                        .padding(.top, Spacing.screenTop)

                    // Profile Card
                    ProfileCard()

                    // Settings Sections
                    VStack(spacing: Spacing.lg) {
                        // App Settings
                        SettingsSection(title: "앱 설정") {
                            SettingToggleItem(
                                icon: "bell.fill",
                                iconColor: .softPeach,
                                title: "알림",
                                description: "매일 아침 알림 받기",
                                isOn: $notificationsEnabled
                            )

                            SettingToggleItem(
                                icon: "heart.fill",
                                iconColor: .gentleLavender,
                                title: "응원 메시지",
                                description: "힘이 되는 메시지 보기",
                                isOn: $encouragementEnabled
                            )

                            SettingToggleItem(
                                icon: "speaker.wave.2.fill",
                                iconColor: .powderBlue,
                                title: "사운드",
                                description: "완료 시 효과음 재생",
                                isOn: $soundEnabled
                            )

                            SettingToggleItem(
                                icon: "moon.fill",
                                iconColor: .deepWarmGray,
                                title: "다크 모드",
                                description: "어두운 화면 사용",
                                isOn: $darkModeEnabled
                            )
                        }

                        // Data Settings
                        SettingsSection(title: "데이터") {
                            SettingNavigationItem(
                                icon: "arrow.up.doc.fill",
                                iconColor: .softMint,
                                title: "데이터 내보내기",
                                description: "내 기록을 저장하기"
                            )

                            SettingNavigationItem(
                                icon: "trash.fill",
                                iconColor: Color.red.opacity(0.7),
                                title: "모든 데이터 삭제",
                                description: "주의: 복구할 수 없습니다",
                                isDestructive: true
                            )
                        }

                        // Info Settings
                        SettingsSection(title: "정보") {
                            SettingNavigationItem(
                                icon: "info.circle.fill",
                                iconColor: .powderBlue,
                                title: "앱 정보",
                                description: "버전 1.0.0"
                            )

                            SettingNavigationItem(
                                icon: "doc.text.fill",
                                iconColor: .mediumGray,
                                title: "이용약관",
                                description: nil
                            )

                            SettingNavigationItem(
                                icon: "lock.fill",
                                iconColor: .mediumGray,
                                title: "개인정보 처리방침",
                                description: nil
                            )
                        }
                    }

                    // About Section
                    VStack(spacing: 8) {
                        Text("133")
                            .textStyle(.headingMedium)
                            .foregroundColor(.softPeach)

                        Text("하루 3분, 3개만 하자")
                            .textStyle(.caption)
                            .foregroundColor(.mediumGray)

                        Text("못해도 괜찮아. 1개만 해도 넌 오늘 어제와 달라.")
                            .textStyle(.captionSmall)
                            .foregroundColor(.lightGray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, Spacing.xl)

                    Spacer(minLength: Spacing.screenBottom)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
}

// MARK: - Profile Card

struct ProfileCard: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.white.opacity(0.2), radius: 10, y: 4)

                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.9))
            }

            // Name
            Text("윤프로")
                .textStyle(.headingMedium)
                .foregroundColor(.white)

            // Subtitle
            Text("꾸준히 실천하는 중")
                .textStyle(.bodySmall)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.cardInternalLarge)
        .background(Color.peachGradient)
        .xLargeRadius()
        .shadow(
            color: Color.softPeach.opacity(0.3),
            radius: 12,
            y: 8
        )
    }
}

// MARK: - Settings Section

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Title
            Text(title)
                .textStyle(.bodySmall)
                .foregroundColor(.mediumGray)
                .padding(.horizontal, Spacing.cardInternal)
                .padding(.bottom, Spacing.sm)

            // Section Content
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .largeRadius()
            .lightShadow()
        }
    }
}

// MARK: - Setting Toggle Item

struct SettingToggleItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String?
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon Box
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .textStyle(.bodyLarge)
                    .foregroundColor(.deepWarmGray)

                if let description = description {
                    Text(description)
                        .textStyle(.captionSmall)
                        .foregroundColor(.mediumGray)
                }
            }

            Spacer()

            // Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.softPeach)
        }
        .padding(Spacing.cardInternal)
        .background(
            Color.white
                .overlay(
                    Rectangle()
                        .fill(Color.warmBeige)
                        .frame(height: 1),
                    alignment: .bottom
                )
        )
    }
}

// MARK: - Setting Navigation Item

struct SettingNavigationItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String?
    var isDestructive: Bool = false

    var body: some View {
        Button(action: {
            // Navigation or action
        }) {
            HStack(spacing: Spacing.md) {
                // Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .textStyle(.bodyLarge)
                        .foregroundColor(isDestructive ? .red : .deepWarmGray)

                    if let description = description {
                        Text(description)
                            .textStyle(.captionSmall)
                            .foregroundColor(.mediumGray)
                    }
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.lightGray)
            }
            .padding(Spacing.cardInternal)
            .background(
                Color.white
                    .overlay(
                        Rectangle()
                            .fill(Color.warmBeige)
                            .frame(height: 1),
                        alignment: .bottom
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
