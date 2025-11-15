//
//  SettingsView.swift
//  133App
//
//  설정 화면
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsManager.self) private var settingsManager
    @State private var showDeleteAlert = false
    @State private var showResetAlert = false
    @State private var showEditProfile = false
    @State private var showExportOptions = false
    @State private var exportFileURL: URL?
    @State private var showShareSheet = false
    @State private var exportError: String?
    @State private var showErrorAlert = false
    @State private var showAppInfo = false
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Header
                    Text("설정")
                        .textStyle(.displayLarge)
                        .padding(.top, Spacing.screenTop)

                    // Profile Card
                    ProfileCard(
                        userName: settingsManager.userName,
                        profileIcon: settingsManager.userProfileIcon,
                        profileImageData: settingsManager.userProfileImageData
                    )
                        .onTapGesture {
                            showEditProfile = true
                        }

                    // Settings Sections
                    VStack(spacing: Spacing.lg) {
                        // App Settings
                        SettingsSection(title: "앱 설정") {
                            SettingToggleItem(
                                icon: "bell.fill",
                                iconColor: .softPeach,
                                title: "알림",
                                description: "매일 아침 알림 받기",
                                isOn: Binding(
                                    get: { settingsManager.notificationsEnabled },
                                    set: { settingsManager.notificationsEnabled = $0 }
                                )
                            )

                            SettingToggleItem(
                                icon: "heart.fill",
                                iconColor: .gentleLavender,
                                title: "응원 메시지",
                                description: "힘이 되는 메시지 보기",
                                isOn: Binding(
                                    get: { settingsManager.encouragementEnabled },
                                    set: { settingsManager.encouragementEnabled = $0 }
                                )
                            )

                            SettingToggleItem(
                                icon: "speaker.wave.2.fill",
                                iconColor: .powderBlue,
                                title: "사운드",
                                description: "완료 시 효과음 재생",
                                isOn: Binding(
                                    get: { settingsManager.soundEnabled },
                                    set: { settingsManager.soundEnabled = $0 }
                                )
                            )

                            SettingToggleItem(
                                icon: "moon.fill",
                                iconColor: .deepWarmGray,
                                title: "다크 모드",
                                description: "어두운 화면 사용",
                                isOn: Binding(
                                    get: { settingsManager.darkModeEnabled },
                                    set: { settingsManager.darkModeEnabled = $0 }
                                )
                            )
                        }

                        // Data Settings
                        SettingsSection(title: "데이터") {
                            SettingNavigationItem(
                                icon: "arrow.up.doc.fill",
                                iconColor: .softMint,
                                title: "데이터 내보내기",
                                description: "내 기록을 저장하기"
                            ) {
                                showExportOptions = true
                            }

                            SettingNavigationItem(
                                icon: "trash.fill",
                                iconColor: Color.red.opacity(0.7),
                                title: "모든 데이터 삭제",
                                description: "주의: 복구할 수 없습니다",
                                isDestructive: true
                            ) {
                                showDeleteAlert = true
                            }
                        }

                        // Info Settings
                        SettingsSection(title: "정보") {
                            SettingNavigationItem(
                                icon: "info.circle.fill",
                                iconColor: .powderBlue,
                                title: "앱 정보",
                                description: "버전 1.0.0"
                            ) {
                                showAppInfo = true
                            }

                            SettingNavigationItem(
                                icon: "doc.text.fill",
                                iconColor: .adaptiveSecondaryText,
                                title: "이용약관",
                                description: nil
                            ) {
                                showTermsOfService = true
                            }

                            SettingNavigationItem(
                                icon: "lock.fill",
                                iconColor: .adaptiveSecondaryText,
                                title: "개인정보 처리방침",
                                description: nil
                            ) {
                                showPrivacyPolicy = true
                            }
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
        .alert("모든 데이터 삭제", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("모든 할일과 통계 데이터가 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.")
        }
        .confirmationDialog("데이터 내보내기", isPresented: $showExportOptions) {
            Button("JSON 형식 (전체 데이터)") {
                exportData(format: .json)
            }
            Button("CSV - 할일 목록") {
                exportData(format: .csvTodos)
            }
            Button("CSV - 통계 데이터") {
                exportData(format: .csvStats)
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("내보낼 데이터 형식을 선택하세요")
        }
        .alert("내보내기 오류", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(exportError ?? "데이터 내보내기 중 오류가 발생했습니다")
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportFileURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $showEditProfile) {
            @Bindable var bindableSettings = settingsManager
            EditProfileView(settingsManager: settingsManager, isPresented: $showEditProfile)
        }
        .sheet(isPresented: $showAppInfo) {
            AppInfoView()
        }
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }
    
    // MARK: - Actions
    
    private enum ExportFormat {
        case json, csvTodos, csvStats
    }
    
    private func exportData(format: ExportFormat) {
        let exportManager = DataExportManager.shared
        
        let result: Result<URL, DataExportManager.ExportError>
        
        switch format {
        case .json:
            result = exportManager.exportAllDataToJSON()
        case .csvTodos:
            result = exportManager.exportTodosToCSV()
        case .csvStats:
            result = exportManager.exportStatsToCSV()
        }
        
        switch result {
        case .success(let url):
            exportFileURL = url
            showShareSheet = true
            HapticManager.shared.success()
        case .failure(let error):
            exportError = error.localizedDescription
            showErrorAlert = true
            HapticManager.shared.error()
        }
    }
    
    private func deleteAllData() {
        // TODO: TodoViewModel과 StatsManager 인스턴스 접근하여 삭제
        // 현재는 알림만 제거
        settingsManager.notificationManager.removeAllNotifications()
        print("모든 데이터 삭제")
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}

// MARK: - Profile Card

struct ProfileCard: View {
    let userName: String
    let profileIcon: String
    let profileImageData: Data?
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Avatar with Edit Indicator
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.white.opacity(0.2), radius: 10, y: 4)

                if let imageData = profileImageData,
                   let uiImage = UIImage(data: imageData) {
                    // 사용자가 선택한 이미지
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                } else {
                    // SF Symbol 아이콘
                    Image(systemName: profileIcon)
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // Edit Badge
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.softPeach)
                    )
                    .offset(x: 28, y: 28)
            }

            // Name
            Text(userName)
                .textStyle(.headingMedium)
                .foregroundColor(.white)

            // Subtitle
            Text("프로필 편집하기")
                .textStyle(.captionSmall)
                .foregroundColor(.white.opacity(0.8))
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
            .background(Color.adaptiveCardBackground)
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
                    .foregroundColor(.adaptiveText)

                if let description = description {
                    Text(description)
                        .textStyle(.captionSmall)
                        .foregroundColor(.adaptiveSecondaryText)
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
            Color.adaptiveCardBackground
                .overlay(
                    Rectangle()
                        .fill(Color.adaptiveDivider)
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
                        .foregroundColor(isDestructive ? .red : .adaptiveText)

                    if let description = description {
                        Text(description)
                            .textStyle(.captionSmall)
                            .foregroundColor(.adaptiveSecondaryText)
                    }
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.adaptiveTertiaryText)
            }
            .padding(Spacing.cardInternal)
            .background(
                Color.adaptiveCardBackground
                    .overlay(
                        Rectangle()
                            .fill(Color.adaptiveDivider)
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
