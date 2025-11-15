//
//  StatsManager.swift
//  133App
//
//  통계 데이터 관리 매니저
//

import Foundation
import Observation

@Observable
class StatsManager {
    private let userDefaults = UserDefaults.standard
    private let statsKey = "daily_stats_history"

    /// 일별 통계 히스토리 (최근 90일)
    private(set) var dailyStatsHistory: [DailyStats] = []

    // MARK: - 캐싱 (성능 최적화)

    /// 주간 통계 캐시
    private var weeklyStatsCache: (stats: WeeklyStats, cacheDate: Date)?

    /// 전체 통계 캐시
    private var totalStatsCache: (completedTodos: Int, focusMinutes: Int, completionRate: Int, cacheDate: Date)?

    /// 연속 실천 일수 캐시
    private var streakCache: (streak: Int, cacheDate: Date)?

    init() {
        loadStats()
    }
    
    // MARK: - Public Methods
    
    /// 오늘의 통계 가져오기
    func getTodayStats() -> DailyStats? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyStatsHistory.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    /// 이번 주 통계 가져오기 (월요일 시작) - 캐싱 적용
    func getThisWeekStats() -> WeeklyStats {
        let calendar = Calendar.current
        let today = Date()

        // 캐시 유효성 검사 (같은 날이면 캐시 사용)
        if let cache = weeklyStatsCache,
           calendar.isDate(cache.cacheDate, inSameDayAs: today) {
            return cache.stats
        }

        // 캐시가 없거나 만료됨 - 새로 계산
        // 이번 주 월요일 찾기
        var weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        // 월요일로 조정 (일요일이 첫날이면)
        if calendar.component(.weekday, from: weekStart) == 1 {
            weekStart = calendar.date(byAdding: .day, value: 1, to: weekStart)!
        }

        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!

        // 이번 주의 일별 통계 필터링
        let weekStats = dailyStatsHistory.filter { stat in
            stat.date >= calendar.startOfDay(for: weekStart) &&
            stat.date <= calendar.startOfDay(for: weekEnd)
        }

        // 7일 데이터 생성 (데이터가 없는 날은 빈 데이터)
        var allDaysStats: [DailyStats] = []
        for dayOffset in 0..<7 {
            if let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) {
                let dayStart = calendar.startOfDay(for: dayDate)
                if let existingStat = weekStats.first(where: { calendar.isDate($0.date, inSameDayAs: dayStart) }) {
                    allDaysStats.append(existingStat)
                } else {
                    allDaysStats.append(DailyStats(date: dayStart))
                }
            }
        }

        let weeklyStats = WeeklyStats(
            startDate: weekStart,
            endDate: weekEnd,
            dailyStats: allDaysStats
        )

        // 캐시 저장
        weeklyStatsCache = (weeklyStats, today)

        return weeklyStats
    }
    
    /// 특정 기간의 통계 가져오기
    func getStats(from startDate: Date, to endDate: Date) -> [DailyStats] {
        let calendar = Calendar.current
        return dailyStatsHistory.filter { stat in
            stat.date >= calendar.startOfDay(for: startDate) &&
            stat.date <= calendar.startOfDay(for: endDate)
        }
    }
    
    /// 연속 실천 일수 계산 - 캐싱 적용
    func getStreakDays() -> Int {
        let calendar = Calendar.current
        let today = Date()

        // 캐시 유효성 검사 (같은 날이면 캐시 사용)
        if let cache = streakCache,
           calendar.isDate(cache.cacheDate, inSameDayAs: today) {
            return cache.streak
        }

        // 캐시가 없거나 만료됨 - 새로 계산
        let sortedStats = dailyStatsHistory
            .filter { $0.isAllCompleted }
            .sorted { $0.date > $1.date } // 최신순

        guard !sortedStats.isEmpty else {
            streakCache = (0, today)
            return 0
        }

        var streak = 0
        var currentDate = calendar.startOfDay(for: today)

        // 오늘부터 역순으로 체크
        for stat in sortedStats {
            let statDate = calendar.startOfDay(for: stat.date)

            // 현재 날짜와 일치하면 streak 증가
            if calendar.isDate(statDate, inSameDayAs: currentDate) {
                streak += 1
                // 하루 전으로 이동
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                // 연속이 끊김
                break
            }
        }

        // 캐시 저장
        streakCache = (streak, today)

        return streak
    }
    
    /// 전체 통계 계산 - 캐싱 적용
    func getTotalStats() -> (completedTodos: Int, focusMinutes: Int, completionRate: Int) {
        let calendar = Calendar.current
        let today = Date()

        // 캐시 유효성 검사 (같은 날이면 캐시 사용)
        if let cache = totalStatsCache,
           calendar.isDate(cache.cacheDate, inSameDayAs: today) {
            return (cache.completedTodos, cache.focusMinutes, cache.completionRate)
        }

        // 캐시가 없거나 만료됨 - 새로 계산
        let totalCompleted = dailyStatsHistory.reduce(0) { $0 + $1.completedTodos }
        let totalMinutes = dailyStatsHistory.reduce(0) { $0 + $1.totalActualMinutes }

        let totalTodos = dailyStatsHistory.reduce(0) { $0 + $1.totalTodos }
        let completionRate = totalTodos > 0 ? Int((Double(totalCompleted) / Double(totalTodos)) * 100) : 0

        // 캐시 저장
        totalStatsCache = (totalCompleted, totalMinutes, completionRate, today)

        return (totalCompleted, totalMinutes, completionRate)
    }
    
    /// 모든 통계 데이터 가져오기 (내보내기용)
    func getAllStats() -> [DailyStats] {
        return dailyStatsHistory.sorted { $0.date > $1.date }
    }
    
    /// 오늘의 통계 업데이트
    func updateTodayStats(todos: [TodoItem]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // 완료된 할일 필터링
        let completedTodos = todos.filter { $0.isCompleted }

        // 통계 계산
        let totalEstimatedMinutes = todos.reduce(0) { $0 + $1.estimatedMinutes }
        let totalActualMinutes = completedTodos.reduce(0) { $0 + ($1.actualMinutes ?? 0) }
        let completedTodoIds = completedTodos.map { $0.id }

        // 기존 통계 찾기
        if let index = dailyStatsHistory.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            // 업데이트
            dailyStatsHistory[index] = DailyStats(
                id: dailyStatsHistory[index].id,
                date: today,
                totalTodos: todos.count,
                completedTodos: completedTodos.count,
                totalEstimatedMinutes: totalEstimatedMinutes,
                totalActualMinutes: totalActualMinutes,
                completedTodoIds: completedTodoIds
            )
        } else {
            // 새로 추가
            let newStats = DailyStats(
                date: today,
                totalTodos: todos.count,
                completedTodos: completedTodos.count,
                totalEstimatedMinutes: totalEstimatedMinutes,
                totalActualMinutes: totalActualMinutes,
                completedTodoIds: completedTodoIds
            )
            dailyStatsHistory.append(newStats)
        }

        // 최근 90일만 유지
        cleanOldStats()

        // 캐시 무효화 (데이터가 변경되었으므로)
        invalidateCache()

        // 저장
        saveStats()
    }

    /// 캐시 무효화
    private func invalidateCache() {
        weeklyStatsCache = nil
        totalStatsCache = nil
        streakCache = nil
    }
    
    // MARK: - Private Methods
    
    private func saveStats() {
        if let encoded = try? JSONEncoder().encode(dailyStatsHistory) {
            userDefaults.set(encoded, forKey: statsKey)
        }
    }
    
    private func loadStats() {
        if let data = userDefaults.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode([DailyStats].self, from: data) {
            dailyStatsHistory = decoded
        }
    }
    
    private func cleanOldStats() {
        let calendar = Calendar.current
        let ninetyDaysAgo = calendar.date(byAdding: .day, value: -90, to: Date())!
        
        dailyStatsHistory = dailyStatsHistory.filter { stat in
            stat.date >= calendar.startOfDay(for: ninetyDaysAgo)
        }
    }
    
    /// 모든 통계 삭제
    func clearAllStats() {
        dailyStatsHistory.removeAll()
        userDefaults.removeObject(forKey: statsKey)
    }
}
