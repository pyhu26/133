//
//  HapticManager.swift
//  133App
//
//  햅틱 피드백 관리 매니저
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    // MARK: - Impact Feedback
    
    /// 가벼운 충격 (체크박스 토글 등)
    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// 중간 충격 (버튼 탭 등)
    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// 강한 충격 (중요한 액션)
    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// 부드러운 충격
    func soft() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    /// 딱딱한 충격
    func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
    // MARK: - Notification Feedback
    
    /// 성공 피드백 (할일 완료 등)
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// 경고 피드백
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// 에러 피드백
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    // MARK: - Selection Feedback
    
    /// 선택 변경 피드백 (슬라이더, 피커 등)
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // MARK: - Custom Patterns
    
    /// 체크박스 토글 패턴
    func checkboxToggle() {
        light()
    }
    
    /// 할일 완료 패턴 (더블 탭 느낌)
    func todoComplete() {
        success()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.light()
        }
    }
    
    /// 타이머 완료 패턴 (3번 탭)
    func timerComplete() {
        heavy()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.heavy()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.success()
        }
    }
    
    /// 타이머 시작 패턴
    func timerStart() {
        medium()
    }
    
    /// 타이머 정지 패턴
    func timerStop() {
        soft()
    }
}
