//
//  StatsView.swift
//  133App
//
//  통계 화면 - 주간/월간 실천 기록
//

import SwiftUI

struct StatsView: View {
    @State private var viewModel = TodoViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Header
                    Text("나의 실천 기록")
                        .textStyle(.displayLarge)
                        .padding(.top, Spacing.screenTop)

                    // Week Progress Card
                    WeekProgressCard(weeklyStats: viewModel.statsManager.getThisWeekStats())

                    // Stats Grid
                    StatsGrid(statsManager: viewModel.statsManager)

                    // Encouragement Card
                    EncouragementCard(message: getEncouragementMessage())

                    // Weekly Timeline (Optional)
                    // WeeklyTimeline()

                    Spacer(minLength: Spacing.screenBottom)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
    }
    
    private func getEncouragementMessage() -> String {
        let streak = viewModel.statsManager.getStreakDays()
        let totalStats = viewModel.statsManager.getTotalStats()
        
        if streak >= 7 {
            return "🔥 \(streak)일 연속! 정말 대단해요!"
        } else if streak >= 3 {
            return "💪 \(streak)일 연속 실천 중! 계속 가보자!"
        } else if totalStats.completedTodos >= 10 {
            return "🌟 벌써 \(totalStats.completedTodos)개나 해냈어요!"
        } else if totalStats.completedTodos > 0 {
            return "꾸준함이 재능이야!"
        } else {
            return "오늘부터 시작해볼까요?"
        }
    }
}

// MARK: - Week Progress Card

struct WeekProgressCard: View {
    let weeklyStats: WeeklyStats
    
    // 요일 이름
    let weekDays = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Week Title
            HStack {
                Text("이번 주")
                    .textStyle(.headingMedium)

                Spacer()

                Text(dateRangeText)
                    .textStyle(.caption)
                    .foregroundColor(.mediumGray)
            }

            // Day Dots
            HStack(spacing: 12) {
                ForEach(Array(weeklyStats.dailyStats.enumerated()), id: \.offset) { index, dayStat in
                    DayDot(
                        day: weekDays[index],
                        isCompleted: dayStat.isAllCompleted,
                        isToday: Calendar.current.isDateInToday(dayStat.date)
                    )
                }
            }

            // Achievement Text
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.softPeach)

                Text("\(weeklyStats.completedDaysCount)일 실천했어요!")
                    .textStyle(.bodyLarge)
                    .foregroundColor(.deepWarmGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(Color.warmBeige.opacity(0.4))
            .mediumRadius()
        }
        .padding(Spacing.cardInternalLarge)
        .background(Color.white)
        .xLargeRadius()
        .lightShadow()
    }
    
    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        let startText = formatter.string(from: weeklyStats.startDate)
        formatter.dateFormat = "d일"
        let endText = formatter.string(from: weeklyStats.endDate)
        return "\(startText) - \(endText)"
    }
}

// MARK: - Day Dot

struct DayDot: View {
    let day: String
    let isCompleted: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(
                        isCompleted ? AnyShapeStyle(Color.peachGradient) :
                        isToday ? AnyShapeStyle(Color.white) :
                        AnyShapeStyle(Color.borderGray)
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(
                                isToday ? Color.softPeach : Color.clear,
                                lineWidth: 3
                            )
                    )
                    .applyShadow(style: isCompleted ? .primary : .secondary)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                } else if isToday {
                    Circle()
                        .fill(Color.softPeach)
                        .frame(width: 8, height: 8)
                }
            }

            Text(day)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(isToday ? .softPeach : .mediumGray)
        }
    }
}

// MARK: - Stats Grid

struct StatsGrid: View {
    let statsManager: StatsManager
    
    var body: some View {
        let totalStats = statsManager.getTotalStats()
        let weeklyStats = statsManager.getThisWeekStats()
        let streak = statsManager.getStreakDays()
        
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Spacing.md),
                GridItem(.flexible(), spacing: Spacing.md)
            ],
            spacing: Spacing.md
        ) {
            StatCard(
                icon: "checkmark.circle.fill",
                value: "\(totalStats.completedTodos)",
                label: "완료한 일",
                color: .gentleLavender
            )

            StatCard(
                icon: "timer",
                value: "\(totalStats.focusMinutes)",
                label: "집중 시간 (분)",
                color: .softMint
            )

            StatCard(
                icon: "flame.fill",
                value: "\(streak)",
                label: "연속 실천 일수",
                color: .softPeach
            )

            StatCard(
                icon: "chart.bar.fill",
                value: "\(totalStats.completionRate)%",
                label: "완료율",
                color: .powderBlue
            )
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: Spacing.md) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)

            // Value
            Text(value)
                .font(.statsValue)
                .foregroundColor(.deepWarmGray)

            // Label
            Text(label)
                .textStyle(.caption)
                .foregroundColor(.mediumGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.xl)
        .background(Color.white)
        .largeRadius()
        .lightShadow()
    }
}

// MARK: - Weekly Timeline (Optional)

struct WeeklyTimeline: View {
    let items = [
        TimelineItem(
            date: "오늘",
            time: "오후 3시",
            title: "아침 스트레칭하기",
            isCompleted: true
        ),
        TimelineItem(
            date: "오늘",
            time: "오전 9시",
            title: "물 한 잔 마시기",
            isCompleted: true
        ),
        TimelineItem(
            date: "어제",
            time: "오후 8시",
            title: "감사일기 쓰기",
            isCompleted: true
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("최근 활동")
                .textStyle(.headingSmall)

            VStack(alignment: .leading, spacing: Spacing.md) {
                ForEach(items) { item in
                    TimelineRow(item: item)
                }
            }
        }
        .padding(Spacing.cardInternalLarge)
        .background(Color.white)
        .largeRadius()
        .lightShadow()
    }
}

struct TimelineItem: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let title: String
    let isCompleted: Bool
}

struct TimelineRow: View {
    let item: TimelineItem

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Dot
            Circle()
                .fill(item.isCompleted ? Color.softPeach : Color.borderGray)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .textStyle(.bodyLarge)
                    .foregroundColor(.deepWarmGray)

                Text("\(item.date) · \(item.time)")
                    .textStyle(.captionSmall)
                    .foregroundColor(.mediumGray)
            }

            Spacer()

            if item.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.gentleLavender)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    StatsView()
}
