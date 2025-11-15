//
//  PrivacyPolicyView.swift
//  133App
//
//  개인정보 처리방침 화면
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.adaptiveBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            Text("개인정보 처리방침")
                                .textStyle(.displayLarge)

                            Text("최종 업데이트: 2025년 1월 15일")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                        .padding(.top, Spacing.screenTop)

                        // Privacy Notice Card
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.softPeach)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("개인정보 수집 없음")
                                    .textStyle(.headingSmall)
                                    .foregroundColor(.adaptiveText)

                                Text("133은 사용자의 개인정보를 수집하거나 외부로 전송하지 않습니다.")
                                    .textStyle(.caption)
                                    .foregroundColor(.adaptiveSecondaryText)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(Spacing.cardInternalLarge)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.softPeach.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.softPeach.opacity(0.3), lineWidth: 2)
                        )

                        // Privacy Sections
                        PrivacySection(
                            number: "1",
                            title: "수집하는 정보",
                            content: """
                            133 앱은 다음의 정보를 사용자 기기에 로컬로만 저장합니다:

                            **앱 사용 데이터 (기기 내부 저장)**
                            • 할 일 목록 및 메모
                            • 완료 여부 및 실제 소요 시간
                            • 일별 통계 데이터 (최근 90일)
                            • 사용자 설정 (알림, 다크모드 등)
                            • 사용자 이름 및 프로필 아이콘

                            **외부 전송 데이터**
                            • 없음

                            모든 데이터는 사용자의 iPhone/iPad에만 저장되며, 외부 서버나 제3자에게 전송되지 않습니다.
                            """
                        )

                        PrivacySection(
                            number: "2",
                            title: "정보의 저장 및 보관",
                            content: """
                            **저장 위치**
                            • 모든 데이터는 사용자 기기의 UserDefaults에 저장됩니다
                            • iCloud 동기화를 사용하지 않습니다
                            • 개발자나 제3자가 이 데이터에 접근할 수 없습니다

                            **보관 기간**
                            • 할 일 데이터: 당일 자정까지 (자동 삭제)
                            • 통계 데이터: 최근 90일간 보관
                            • 설정 데이터: 앱을 삭제할 때까지

                            **데이터 삭제**
                            • 사용자가 앱을 삭제하면 모든 데이터가 함께 삭제됩니다
                            • 설정 화면에서 '모든 데이터 삭제' 기능을 사용할 수 있습니다
                            """
                        )

                        PrivacySection(
                            number: "3",
                            title: "제3자 서비스",
                            content: """
                            133 앱은 다음과 같은 제3자 서비스를 사용하지 않습니다:

                            ✗ 분석 도구 (Analytics)
                            ✗ 광고 네트워크
                            ✗ 소셜 미디어 SDK
                            ✗ 크래시 리포팅 도구
                            ✗ 클라우드 저장소

                            앱은 완전히 오프라인으로 작동하며, 인터넷 연결이 필요하지 않습니다.
                            """
                        )

                        PrivacySection(
                            number: "4",
                            title: "알림 권한",
                            content: """
                            133 앱은 다음의 목적으로만 알림 권한을 요청합니다:

                            **로컬 알림**
                            • 매일 아침 할 일 확인 알림
                            • 타이머 완료 알림

                            **권한 사용 방식**
                            • 모든 알림은 기기 내부에서만 처리됩니다
                            • 푸시 알림 서버를 사용하지 않습니다
                            • 사용자가 언제든지 설정에서 알림을 끌 수 있습니다

                            알림 권한을 거부해도 앱의 핵심 기능은 정상적으로 사용할 수 있습니다.
                            """
                        )

                        PrivacySection(
                            number: "5",
                            title: "사진 라이브러리 접근",
                            content: """
                            133 앱은 프로필 사진 설정을 위해 사진 라이브러리 접근 권한을 요청할 수 있습니다:

                            **사용 목적**
                            • 사용자 프로필 이미지 선택

                            **처리 방식**
                            • 선택한 이미지는 기기에만 저장됩니다
                            • 외부로 전송되지 않습니다
                            • 사용자가 언제든지 이미지를 삭제할 수 있습니다

                            이 권한은 선택사항이며, 거부해도 앱의 핵심 기능을 모두 사용할 수 있습니다.
                            """
                        )

                        PrivacySection(
                            number: "6",
                            title: "데이터 백업",
                            content: """
                            **iCloud 백업**
                            • iOS의 iCloud 백업 기능을 통해 앱 데이터가 자동으로 백업될 수 있습니다
                            • 이는 Apple의 iCloud 서비스이며, 개발자는 이 데이터에 접근할 수 없습니다
                            • iCloud 백업은 iOS 설정에서 제어할 수 있습니다

                            **데이터 내보내기**
                            • 사용자가 직접 데이터를 JSON/CSV 형식으로 내보낼 수 있습니다
                            • 내보낸 파일은 사용자가 직접 관리합니다
                            """
                        )

                        PrivacySection(
                            number: "7",
                            title: "어린이 프라이버시",
                            content: """
                            133 앱은 13세 미만의 어린이로부터 의도적으로 개인정보를 수집하지 않습니다.

                            • 앱 사용에 연령 제한은 없습니다
                            • 개인정보를 수집하지 않으므로 어린이도 안전하게 사용할 수 있습니다
                            • 부모님의 감독 하에 사용하시기를 권장합니다
                            """
                        )

                        PrivacySection(
                            number: "8",
                            title: "개인정보 처리방침 변경",
                            content: """
                            본 개인정보 처리방침은 필요에 따라 업데이트될 수 있습니다:

                            • 중요한 변경사항이 있을 경우 앱 내에서 공지합니다
                            • 최신 버전은 앱의 설정 화면에서 확인할 수 있습니다
                            • 변경 사항은 업데이트된 날짜부터 효력을 발생합니다

                            정기적으로 본 정책을 확인하시기 바랍니다.
                            """
                        )

                        PrivacySection(
                            number: "9",
                            title: "문의하기",
                            content: """
                            개인정보 처리방침과 관련하여 문의사항이 있으시면 연락 주시기 바랍니다:

                            • 개발자: 윤프로
                            • 이메일: privacy@133app.com (예시)

                            사용자의 프라이버시를 최우선으로 생각하며, 문의사항에 성실히 답변드리겠습니다.
                            """
                        )

                        // Footer
                        VStack(spacing: Spacing.sm) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.softPeach)

                                Text("사용자의 프라이버시를 존중합니다")
                                    .textStyle(.bodySmall)
                                    .foregroundColor(.adaptiveText)
                                    .fontWeight(.semibold)
                            }

                            Text("133은 사용자 데이터를 절대 수집하거나 판매하지 않습니다.")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.xl)

                        Spacer(minLength: Spacing.screenBottom)
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
            }
            .navigationTitle("개인정보 처리방침")
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

// MARK: - Privacy Section

struct PrivacySection: View {
    let number: String
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Section Header
            HStack(spacing: Spacing.sm) {
                Text(number)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.softPeach)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.softPeach.opacity(0.15))
                    )

                Text(title)
                    .textStyle(.headingMedium)
                    .foregroundColor(.adaptiveText)
            }

            // Section Content
            Text(content)
                .textStyle(.bodyRegular)
                .foregroundColor(.adaptiveSecondaryText)
                .lineSpacing(6)
        }
        .padding(Spacing.cardInternalLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.adaptiveCardBackground)
        .largeRadius()
        .lightShadow()
    }
}

// MARK: - Preview

#Preview {
    PrivacyPolicyView()
}
