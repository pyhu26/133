//
//  TodoItem.swift
//  133App
//
//  할 일 데이터 모델
//

import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var estimatedMinutes: Int
    var memo: String?
    var isCompleted: Bool
    var completedAt: Date?
    var actualMinutes: Int?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        estimatedMinutes: Int,
        memo: String? = nil,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        actualMinutes: Int? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.estimatedMinutes = estimatedMinutes
        self.memo = memo
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.actualMinutes = actualMinutes
        self.createdAt = createdAt
    }

    /// 할 일 완료 처리
    mutating func complete(actualMinutes: Int? = nil) {
        isCompleted = true
        completedAt = Date()
        if let minutes = actualMinutes {
            self.actualMinutes = minutes
        }
    }

    /// 할 일 완료 취소
    mutating func uncomplete() {
        isCompleted = false
        completedAt = nil
        actualMinutes = nil
    }
}

// MARK: - Sample Data

extension TodoItem {
    static let sample1 = TodoItem(
        title: "아침 스트레칭하기",
        estimatedMinutes: 3,
        memo: "목과 어깨 위주로"
    )

    static let sample2 = TodoItem(
        title: "물 한 잔 마시기",
        estimatedMinutes: 3
    )

    static let sample3 = TodoItem(
        title: "감사일기 쓰기",
        estimatedMinutes: 5,
        memo: "오늘 감사한 일 3가지"
    )

    static let samples = [sample1, sample2, sample3]
}
