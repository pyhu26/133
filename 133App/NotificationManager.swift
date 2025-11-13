//
//  NotificationManager.swift
//  133App
//
//  알림 관리 매니저
//

import Foundation
import UserNotifications
import Observation

@Observable
class NotificationManager {
    static let shared = NotificationManager()
    
    private let center = UNUserNotificationCenter.current()
    var isAuthorized = false
    
    init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    /// 알림 권한 확인
    func checkAuthorizationStatus() {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    /// 알림 권한 요청
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("알림 권한 요청 실패: \(error)")
            return false
        }
    }
    
    // MARK: - Daily Morning Notification
    
    /// 매일 아침 알림 스케줄 (오전 9시)
    func scheduleDailyMorningNotification(enabled: Bool) async {
        // 기존 알림 제거
        center.removePendingNotificationRequests(withIdentifiers: ["daily_morning"])
        
        guard enabled else { return }
        
        // 권한 확인
        if !isAuthorized {
            let granted = await requestAuthorization()
            if !granted { return }
        }
        
        // 알림 내용 설정
        let content = UNMutableNotificationContent()
        content.title = "좋은 아침이에요! ☀️"
        content.body = "오늘은 어떤 3가지를 해볼까요? 작은 실천이 큰 변화를 만들어요."
        content.sound = .default
        content.badge = 1
        
        // 매일 오전 9시에 알림
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "daily_morning",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
            print("매일 아침 알림 스케줄 완료")
        } catch {
            print("알림 스케줄 실패: \(error)")
        }
    }
    
    // MARK: - Timer Completion Notification
    
    /// 타이머 완료 알림 (앱이 백그라운드일 때)
    func scheduleTimerCompletionNotification(todoTitle: String, delay: TimeInterval) async {
        // 기존 타이머 알림 제거
        center.removePendingNotificationRequests(withIdentifiers: ["timer_completion"])
        
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "타이머 완료! 🎉"
        content.body = "'\(todoTitle)' 완료했어요! 정말 멋져요!"
        content.sound = .default
        content.categoryIdentifier = "TIMER_COMPLETE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(
            identifier: "timer_completion",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
            print("타이머 완료 알림 스케줄: \(delay)초 후")
        } catch {
            print("타이머 알림 스케줄 실패: \(error)")
        }
    }
    
    /// 타이머 완료 알림 취소
    func cancelTimerCompletionNotification() {
        center.removePendingNotificationRequests(withIdentifiers: ["timer_completion"])
    }
    
    // MARK: - Todo Reminder
    
    /// 할일 리마인더 알림 (저녁 8시)
    func scheduleTodoReminder(enabled: Bool, incompleteTodosCount: Int) async {
        // 기존 리마인더 제거
        center.removePendingNotificationRequests(withIdentifiers: ["todo_reminder"])
        
        guard enabled && incompleteTodosCount > 0 else { return }
        
        // 권한 확인
        if !isAuthorized {
            let granted = await requestAuthorization()
            if !granted { return }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "아직 \(incompleteTodosCount)개 남았어요 💪"
        content.body = "오늘 하루도 얼마 안 남았어요. 지금 시작해볼까요?"
        content.sound = .default
        
        // 오늘 저녁 8시
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "todo_reminder",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
            print("할일 리마인더 스케줄 완료")
        } catch {
            print("리마인더 스케줄 실패: \(error)")
        }
    }
    
    // MARK: - Badge Management
    
    /// 앱 배지 업데이트 (미완료 할일 개수)
    func updateBadgeCount(_ count: Int) {
        UNUserNotificationCenter.current().setBadgeCount(count)
    }
    
    /// 배지 초기화
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    // MARK: - Remove All
    
    /// 모든 알림 제거
    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        clearBadge()
    }
}
