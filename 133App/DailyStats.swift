//
//  DailyStats.swift
//  133App
//
//  일별 통계 데이터 모델
//

import Foundation

/// 하루 통계 데이터
struct DailyStats: Codable, Identifiable {
    let id: UUID
    let date: Date
    var totalTodos: Int
    var completedTodos: Int
    var totalEstimatedMinutes: Int
    var totalActualMinutes: Int
    var completedTodoIds: [UUID]
    
    init(
        id: UUID = UUID(),
        date: Date,
        totalTodos: Int = 0,
        completedTodos: Int = 0,
        totalEstimatedMinutes: Int = 0,
        totalActualMinutes: Int = 0,
        completedTodoIds: [UUID] = []
    ) {
        self.id = id
        self.date = date
        self.totalTodos = totalTodos
        self.completedTodos = completedTodos
        self.totalEstimatedMinutes = totalEstimatedMinutes
        self.totalActualMinutes = totalActualMinutes
        self.completedTodoIds = completedTodoIds
    }
    
    /// 완료율 (0-100)
    var completionRate: Int {
        guard totalTodos > 0 else { return 0 }
        return Int((Double(completedTodos) / Double(totalTodos)) * 100)
    }
    
    /// 모든 할일이 완료되었는지
    var isAllCompleted: Bool {
        totalTodos > 0 && completedTodos == totalTodos
    }
}

/// 주간 통계 데이터
struct WeeklyStats {
    let startDate: Date
    let endDate: Date
    let dailyStats: [DailyStats]
    
    /// 주간 완료된 날짜 수
    var completedDaysCount: Int {
        dailyStats.filter { $0.isAllCompleted }.count
    }
    
    /// 주간 총 완료된 할일 개수
    var totalCompletedTodos: Int {
        dailyStats.reduce(0) { $0 + $1.completedTodos }
    }
    
    /// 주간 총 집중 시간 (분)
    var totalFocusMinutes: Int {
        dailyStats.reduce(0) { $0 + $1.totalActualMinutes }
    }
    
    /// 주간 평균 완료율
    var averageCompletionRate: Int {
        let totalRate = dailyStats.reduce(0) { $0 + $1.completionRate }
        let daysWithTodos = dailyStats.filter { $0.totalTodos > 0 }.count
        guard daysWithTodos > 0 else { return 0 }
        return totalRate / daysWithTodos
    }
}
