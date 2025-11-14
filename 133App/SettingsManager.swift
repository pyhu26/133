//
//  SettingsManager.swift
//  133App
//
//  앱 설정 관리 매니저
//

import Foundation
import Observation

@Observable
class SettingsManager {
    private let userDefaults = UserDefaults.standard
    
    // 설정 키
    private enum Keys {
        static let notificationsEnabled = "settings_notifications_enabled"
        static let encouragementEnabled = "settings_encouragement_enabled"
        static let soundEnabled = "settings_sound_enabled"
        static let darkModeEnabled = "settings_dark_mode_enabled"
        static let userName = "settings_user_name"
        static let userProfileIcon = "settings_user_profile_icon"
        static let userProfileImageData = "settings_user_profile_image_data"
    }
    
    // MARK: - Properties
    
    /// 알림 설정
    var notificationsEnabled: Bool {
        didSet {
            userDefaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled)
            Task {
                await handleNotificationSettingChange()
            }
        }
    }
    
    /// 응원 메시지 설정
    var encouragementEnabled: Bool {
        didSet {
            userDefaults.set(encouragementEnabled, forKey: Keys.encouragementEnabled)
        }
    }
    
    /// 사운드 설정
    var soundEnabled: Bool {
        didSet {
            userDefaults.set(soundEnabled, forKey: Keys.soundEnabled)
            SoundManager.shared.setEnabled(soundEnabled)
        }
    }
    
    /// 다크 모드 설정
    var darkModeEnabled: Bool {
        didSet {
            userDefaults.set(darkModeEnabled, forKey: Keys.darkModeEnabled)
        }
    }
    
    /// 사용자 이름
    var userName: String {
        didSet {
            userDefaults.set(userName, forKey: Keys.userName)
        }
    }
    
    /// 사용자 프로필 아이콘
    var userProfileIcon: String {
        didSet {
            userDefaults.set(userProfileIcon, forKey: Keys.userProfileIcon)
        }
    }
    
    /// 사용자 프로필 이미지 데이터
    var userProfileImageData: Data? {
        didSet {
            userDefaults.set(userProfileImageData, forKey: Keys.userProfileImageData)
        }
    }
    
    var notificationManager: NotificationManager
    
    // MARK: - Initialization
    
    init(notificationManager: NotificationManager = NotificationManager()) {
        self.notificationManager = notificationManager
        
        // UserDefaults에서 설정 로드
        self.notificationsEnabled = userDefaults.bool(forKey: Keys.notificationsEnabled)
        self.encouragementEnabled = userDefaults.bool(forKey: Keys.encouragementEnabled)
        self.soundEnabled = userDefaults.bool(forKey: Keys.soundEnabled)
        self.darkModeEnabled = userDefaults.bool(forKey: Keys.darkModeEnabled)
        self.userName = userDefaults.string(forKey: Keys.userName) ?? "윤프로"
        self.userProfileIcon = userDefaults.string(forKey: Keys.userProfileIcon) ?? "person.fill"
        self.userProfileImageData = userDefaults.data(forKey: Keys.userProfileImageData)
        
        // 기본값 설정 (첫 실행)
        if userDefaults.object(forKey: Keys.notificationsEnabled) == nil {
            self.notificationsEnabled = true
            self.encouragementEnabled = true
            self.soundEnabled = true
            self.darkModeEnabled = false
        }
        
        // SoundManager 초기 설정
        SoundManager.shared.setEnabled(self.soundEnabled)
    }
    
    // MARK: - Notification Handling
    
    private func handleNotificationSettingChange() async {
        await notificationManager.scheduleDailyMorningNotification(enabled: notificationsEnabled)
    }
    
    // MARK: - Reset
    
    /// 모든 설정 초기화
    func resetToDefaults() {
        notificationsEnabled = true
        encouragementEnabled = true
        soundEnabled = true
        darkModeEnabled = false
        userName = "윤프로"
        userProfileIcon = "person.fill"
        userProfileImageData = nil
    }
}
