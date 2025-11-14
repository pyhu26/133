//
//  DataExportManager.swift
//  133App
//
//  데이터 내보내기 관리자
//

import Foundation
import UIKit

class DataExportManager {
    static let shared = DataExportManager()
    
    private init() {}
    
    // MARK: - Export Data Structure
    
    struct ExportData: Codable {
        let exportDate: Date
        let appVersion: String
        let userData: UserData
        let todos: [TodoItemExport]
        let stats: [DailyStatsExport]
        
        struct UserData: Codable {
            let userName: String
            let userProfileIcon: String
            let notificationsEnabled: Bool
            let encouragementEnabled: Bool
            let soundEnabled: Bool
        }
        
        struct TodoItemExport: Codable {
            let id: String
            let title: String
            let estimatedMinutes: Int
            let actualMinutes: Int?
            let memo: String?
            let isCompleted: Bool
            let createdAt: Date
            let completedAt: Date?
        }
        
        struct DailyStatsExport: Codable {
            let date: Date
            let totalTodos: Int
            let completedCount: Int
            let totalEstimatedMinutes: Int
            let totalActualMinutes: Int
            let completionRate: Int
        }
    }
    
    // MARK: - Export Methods
    
    /// 모든 데이터를 JSON으로 내보내기 (UserDefaults에서 직접 읽기)
    func exportAllDataToJSON() -> Result<URL, ExportError> {
        do {
            // Settings 로드
            let settingsManager = SettingsManager()
            
            // Todos 로드 (오늘 날짜)
            let todos = loadTodosFromUserDefaults()
            
            // Stats 로드
            let statsManager = StatsManager()
            
            // Export 데이터 생성
            let exportData = createExportData(
                settingsManager: settingsManager,
                todos: todos,
                statsManager: statsManager
            )
            
            // JSON 인코딩
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let jsonData = try encoder.encode(exportData)
            
            // 임시 파일 생성
            let fileName = "133App_Export_\(formatDateForFile(Date())).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try jsonData.write(to: tempURL)
            
            return .success(tempURL)
        } catch {
            return .failure(.encodingFailed(error))
        }
    }
    
    /// CSV 형식으로 할일 내보내기
    func exportTodosToCSV() -> Result<URL, ExportError> {
        do {
            let todos = loadTodosFromUserDefaults()
            
            var csvString = "날짜,제목,예상시간(분),실제시간(분),완료여부,메모\n"
            
            for todo in todos {
                let row = [
                    formatDateForDisplay(todo.createdAt),
                    escapeCsvField(todo.title),
                    "\(todo.estimatedMinutes)",
                    todo.actualMinutes != nil ? "\(todo.actualMinutes!)" : "",
                    todo.isCompleted ? "완료" : "미완료",
                    escapeCsvField(todo.memo ?? "")
                ]
                csvString += row.joined(separator: ",") + "\n"
            }
            
            let fileName = "133App_Todos_\(formatDateForFile(Date())).csv"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try csvString.write(to: tempURL, atomically: true, encoding: .utf8)
            
            return .success(tempURL)
        } catch {
            return .failure(.writeFailed(error))
        }
    }
    
    /// 통계 데이터를 CSV로 내보내기
    func exportStatsToCSV() -> Result<URL, ExportError> {
        do {
            let statsManager = StatsManager()
            
            var csvString = "날짜,총할일,완료개수,예상시간(분),실제시간(분),완료율(%)\n"
            
            let allStats = statsManager.getAllStats()
            
            for stat in allStats.sorted(by: { $0.date < $1.date }) {
                let row = [
                    formatDateForDisplay(stat.date),
                    "\(stat.totalTodos)",
                    "\(stat.completedTodos)",
                    "\(stat.totalEstimatedMinutes)",
                    "\(stat.totalActualMinutes)",
                    "\(stat.completionRate)"
                ]
                csvString += row.joined(separator: ",") + "\n"
            }
            
            let fileName = "133App_Stats_\(formatDateForFile(Date())).csv"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try csvString.write(to: tempURL, atomically: true, encoding: .utf8)
            
            return .success(tempURL)
        } catch {
            return .failure(.writeFailed(error))
        }
    }
    
    // MARK: - Private Helpers
    
    /// UserDefaults에서 오늘의 할일 로드
    private func loadTodosFromUserDefaults() -> [TodoItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todosKey = "todos_\(dateFormatter.string(from: Date()))"
        
        if let data = UserDefaults.standard.data(forKey: todosKey),
           let todos = try? JSONDecoder().decode([TodoItem].self, from: data) {
            return todos
        }
        return []
    }
    
    /// CSV 필드 이스케이프 (쉼표, 개행 처리)
    private func escapeCsvField(_ field: String) -> String {
        if field.contains(",") || field.contains("\n") || field.contains("\"") {
            return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return field
    }
    
    private func createExportData(
        settingsManager: SettingsManager,
        todos: [TodoItem],
        statsManager: StatsManager
    ) -> ExportData {
        // User Data
        let userData = ExportData.UserData(
            userName: settingsManager.userName,
            userProfileIcon: settingsManager.userProfileIcon,
            notificationsEnabled: settingsManager.notificationsEnabled,
            encouragementEnabled: settingsManager.encouragementEnabled,
            soundEnabled: settingsManager.soundEnabled
        )
        
        // Todos
        let todosExport = todos.map { todo in
            ExportData.TodoItemExport(
                id: todo.id.uuidString,
                title: todo.title,
                estimatedMinutes: todo.estimatedMinutes,
                actualMinutes: todo.actualMinutes,
                memo: todo.memo,
                isCompleted: todo.isCompleted,
                createdAt: todo.createdAt,
                completedAt: todo.completedAt
            )
        }
        
        // Stats
        let allStats = statsManager.getAllStats()
        let statsExport = allStats.map { stat in
            ExportData.DailyStatsExport(
                date: stat.date,
                totalTodos: stat.totalTodos,
                completedCount: stat.completedTodos,
                totalEstimatedMinutes: stat.totalEstimatedMinutes,
                totalActualMinutes: stat.totalActualMinutes,
                completionRate: stat.completionRate
            )
        }
        
        return ExportData(
            exportDate: Date(),
            appVersion: "1.0.0",
            userData: userData,
            todos: todosExport,
            stats: statsExport
        )
    }
    
    private func formatDateForFile(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        return formatter.string(from: date)
    }
    
    private func formatDateForDisplay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    // MARK: - Error Types
    
    enum ExportError: LocalizedError {
        case encodingFailed(Error)
        case writeFailed(Error)
        case noData
        
        var errorDescription: String? {
            switch self {
            case .encodingFailed(let error):
                return "데이터 인코딩 실패: \(error.localizedDescription)"
            case .writeFailed(let error):
                return "파일 쓰기 실패: \(error.localizedDescription)"
            case .noData:
                return "내보낼 데이터가 없습니다"
            }
        }
    }
}
