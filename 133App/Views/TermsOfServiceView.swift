//
//  TermsOfServiceView.swift
//  133App
//
//  이용약관 화면
//

import SwiftUI

struct TermsOfServiceView: View {
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
                            Text("133 이용약관")
                                .textStyle(.displayLarge)

                            Text("최종 업데이트: 2025년 1월 15일")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)
                        }
                        .padding(.top, Spacing.screenTop)

                        // Terms Sections
                        TermsSection(
                            number: "1",
                            title: "서비스 이용",
                            content: """
                            133 앱(이하 "서비스")은 사용자의 할 일 관리를 돕기 위해 제공됩니다.

                            • 본 서비스는 무료로 제공됩니다
                            • 사용자는 서비스를 개인적인 용도로만 사용할 수 있습니다
                            • 서비스의 기능과 내용은 사전 고지 없이 변경될 수 있습니다
                            """
                        )

                        TermsSection(
                            number: "2",
                            title: "사용자의 책임",
                            content: """
                            사용자는 다음 행위를 하여서는 안 됩니다:

                            • 서비스를 불법적인 목적으로 사용하는 행위
                            • 타인의 개인정보를 무단으로 수집하는 행위
                            • 서비스의 정상적인 운영을 방해하는 행위
                            • 서비스를 역공학, 디컴파일, 디스어셈블하는 행위
                            """
                        )

                        TermsSection(
                            number: "3",
                            title: "데이터 저장",
                            content: """
                            본 서비스는 다음의 데이터를 사용자 기기에 로컬로 저장합니다:

                            • 할 일 목록 및 완료 상태
                            • 타이머 사용 기록
                            • 통계 데이터 (최근 90일)
                            • 앱 설정 정보

                            모든 데이터는 사용자의 기기에만 저장되며, 외부 서버로 전송되지 않습니다.
                            """
                        )

                        TermsSection(
                            number: "4",
                            title: "서비스 제공의 중단",
                            content: """
                            다음의 경우 서비스 제공이 일시적으로 중단될 수 있습니다:

                            • 시스템 점검, 유지보수, 업그레이드
                            • 천재지변, 비상사태 등 불가항력적인 사유
                            • 기타 기술적인 문제

                            서비스 중단 시 가능한 한 사전에 공지하도록 노력하겠습니다.
                            """
                        )

                        TermsSection(
                            number: "5",
                            title: "면책사항",
                            content: """
                            본 서비스는 "있는 그대로" 제공됩니다:

                            • 서비스 이용으로 발생하는 손해에 대해 책임을 지지 않습니다
                            • 서비스의 정확성, 신뢰성, 완전성을 보장하지 않습니다
                            • 사용자 기기의 문제로 인한 데이터 손실에 대해 책임지지 않습니다

                            중요한 데이터는 반드시 백업하시기 바랍니다.
                            """
                        )

                        TermsSection(
                            number: "6",
                            title: "약관의 변경",
                            content: """
                            본 약관은 필요에 따라 변경될 수 있습니다:

                            • 변경 시 앱 내 공지사항을 통해 알려드립니다
                            • 중요한 변경사항은 7일 전에 사전 공지합니다
                            • 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단할 수 있습니다
                            """
                        )

                        TermsSection(
                            number: "7",
                            title: "문의",
                            content: """
                            서비스 이용과 관련하여 문의사항이 있으시면 연락 주시기 바랍니다.

                            • 개발자: 윤프로
                            • 이메일: support@133app.com (예시)

                            문의하신 내용은 영업일 기준 3일 이내에 답변드리도록 하겠습니다.
                            """
                        )

                        // Footer
                        VStack(spacing: Spacing.sm) {
                            Text("본 약관을 주의 깊게 읽어보시기 바랍니다.")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)
                                .multilineTextAlignment(.center)

                            Text("서비스를 계속 사용하시면 본 약관에 동의하는 것으로 간주됩니다.")
                                .textStyle(.captionSmall)
                                .foregroundColor(.adaptiveTertiaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.xl)

                        Spacer(minLength: Spacing.screenBottom)
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                }
            }
            .navigationTitle("이용약관")
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

// MARK: - Terms Section

struct TermsSection: View {
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
    TermsOfServiceView()
}
