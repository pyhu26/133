//
//  TodoViewModel.swift
//  133App
//
//  할 일 관리 ViewModel
//

import Foundation
import SwiftUI
import Observation

@Observable
class TodoViewModel {
    var todos: [TodoItem] = []
    var statsManager = StatsManager()

    /// 하루 최대 할 일 개수
    private let maxTodos = 3

    /// Debounce를 위한 Task 저장
    private var saveTask: Task<Void, Never>?
    private var updateStatsTask: Task<Void, Never>?

    init() {
        loadTodos()
        updateStats()
    }

    deinit {
        // Task 정리
        saveTask?.cancel()
        updateStatsTask?.cancel()
    }

    // MARK: - Computed Properties

    /// 오늘 남은 슬롯 개수
    var remainingSlots: Int {
        maxTodos - todos.count
    }

    /// 할 일을 더 추가할 수 있는지
    var canAddMore: Bool {
        todos.count < maxTodos
    }

    /// 완료된 할 일 개수
    var completedCount: Int {
        todos.filter { $0.isCompleted }.count
    }

    /// 완료율 (퍼센트)
    var completionRate: Int {
        guard !todos.isEmpty else { return 0 }
        return Int((Double(completedCount) / Double(todos.count)) * 100)
    }

    /// 모든 할 일이 완료되었는지
    var isAllCompleted: Bool {
        !todos.isEmpty && todos.allSatisfy { $0.isCompleted }
    }

    // MARK: - Actions

    /// 할 일 추가
    func addTodo(title: String, estimatedMinutes: Int, memo: String? = nil) {
        guard canAddMore else { return }

        let newTodo = TodoItem(
            title: title,
            estimatedMinutes: estimatedMinutes,
            memo: memo
        )

        todos.append(newTodo)
        saveTodos()
        updateStats()
    }

    /// 할 일 완료 토글
    func toggleComplete(_ todo: TodoItem) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }

        if todos[index].isCompleted {
            todos[index].uncomplete()
        } else {
            todos[index].complete()
        }

        saveTodos()
        updateStats()
    }

    /// 할 일 완료 처리 (타이머에서 사용)
    func completeTodo(_ todo: TodoItem, actualMinutes: Int) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        todos[index].complete(actualMinutes: actualMinutes)
        saveTodos()
        updateStats()
    }
    
    /// 할 일 수정
    func updateTodo(_ todo: TodoItem, title: String, estimatedMinutes: Int, memo: String?) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        
        // 완료된 할일은 수정 불가
        guard !todos[index].isCompleted else {
            print("완료된 할일은 수정할 수 없습니다")
            return
        }
        
        todos[index].title = title
        todos[index].estimatedMinutes = estimatedMinutes
        todos[index].memo = memo
        
        saveTodos()
        updateStats()
    }

    /// 할 일 삭제
    func deleteTodo(_ todo: TodoItem) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
        updateStats()
    }

    /// 모든 할 일 삭제
    func clearAllTodos() {
        todos.removeAll()
        saveTodos()
        updateStats()
    }

    // MARK: - Encouragement Messages

    /// 시간대별 인사말
    func getGreeting(userName: String = "윤프로") -> (icon: String, message: String, subtitle: String) {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return ("☀️", "좋은 아침, \(userName)님", "오늘도 천천히 시작해요")
        case 12..<17:
            return ("🌤️", "좋은 오후, \(userName)님", "오늘도 잘 지내고 있나요?")
        case 17..<21:
            return ("🌆", "좋은 저녁, \(userName)님", "하루 마무리 잘하고 있나요?")
        default:
            return ("🌙", "편안한 밤, \(userName)님", "오늘도 수고 많았어요")
        }
    }

    /// 진행 상황에 따른 응원 메시지
    func getEncouragementMessage() -> String {
        switch completedCount {
        case 0:
            if todos.isEmpty {
                return "오늘은 뭐 해볼까요?"
            } else {
                return "1개만 해도 충분해요"
            }
        case 1:
            return "해냈어! 벌써 1개! 오늘 너 어제와 달라!"
        case 2:
            return "와! 2개나 했어! 정말 멋져!"
        case 3:
            return "완벽해! 오늘 3개 다 해냈어!"
        default:
            return "오늘도 잘 하고 있어요!"
        }
    }

    /// 완료 시 축하 메시지
    func getCompletionMessage() -> String {
        let messages = [
            "해냈어! 너 정말 멋져!",
            "좋아, 시작이 반이야!",
            "오늘 너, 어제와 달라!",
            "이대로만 가면 돼!",
            "할 수 있어, 화이팅!"
        ]
        return messages.randomElement() ?? "잘했어요!"
    }

    // MARK: - Persistence

    private var todosKey: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "todos_\(dateFormatter.string(from: Date()))"
    }

    /// Debounced save - 0.5초 후에 저장 (빠른 연속 변경 시 성능 개선)
    private func saveTodos() {
        // 기존 저장 작업 취소
        saveTask?.cancel()

        // 새로운 저장 작업 예약
        saveTask = Task { @MainActor in
            // 0.5초 대기
            try? await Task.sleep(nanoseconds: 500_000_000)

            // Task가 취소되지 않았으면 저장
            guard !Task.isCancelled else { return }

            if let encoded = try? JSONEncoder().encode(todos) {
                UserDefaults.standard.set(encoded, forKey: todosKey)
            }
        }
    }

    /// 즉시 저장 (앱 종료 시 등 중요한 경우)
    func saveImmediately() {
        saveTask?.cancel()
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }

    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: todosKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }

    // MARK: - Sample Data (개발용)

    func loadSampleData() {
        todos = TodoItem.samples
        saveTodos()
        updateStats()
    }
    
    // MARK: - Stats

    /// Debounced 통계 업데이트 - 0.3초 후에 업데이트 (빠른 연속 변경 시 성능 개선)
    private func updateStats() {
        // 기존 업데이트 작업 취소
        updateStatsTask?.cancel()

        // 새로운 업데이트 작업 예약
        updateStatsTask = Task { @MainActor in
            // 0.3초 대기
            try? await Task.sleep(nanoseconds: 300_000_000)

            // Task가 취소되지 않았으면 업데이트
            guard !Task.isCancelled else { return }

            statsManager.updateTodayStats(todos: todos)
        }
    }

    /// 즉시 통계 업데이트
    func updateStatsImmediately() {
        updateStatsTask?.cancel()
        statsManager.updateTodayStats(todos: todos)
    }
}
