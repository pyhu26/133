//
//  SoundManager.swift
//  133App
//
//  사운드 효과 관리 매니저
//

import AVFoundation
import Observation

@Observable
class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    var isEnabled: Bool = true
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
    
    // MARK: - System Sounds
    
    /// 체크 사운드 (체크박스 토글)
    func playCheck() {
        guard isEnabled else { return }
        playSystemSound(1104) // Tock sound
    }
    
    /// 완료 사운드 (할일 완료)
    func playComplete() {
        guard isEnabled else { return }
        playSystemSound(1054) // Message sent sound
    }
    
    /// 타이머 시작 사운드
    func playTimerStart() {
        guard isEnabled else { return }
        playSystemSound(1103) // Begin record sound
    }
    
    /// 타이머 완료 사운드
    func playTimerComplete() {
        guard isEnabled else { return }
        playSystemSound(1025) // New mail sound
    }
    
    /// 버튼 탭 사운드
    func playTap() {
        guard isEnabled else { return }
        playSystemSound(1104) // Tock sound
    }
    
    /// 에러 사운드
    func playError() {
        guard isEnabled else { return }
        playSystemSound(1053) // Alert sound
    }
    
    // MARK: - Helper Methods
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 사운드 활성화/비활성화
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    // MARK: - Custom Sound (향후 확장용)
    
    /// 커스텀 사운드 파일 재생
    /// - Parameter fileName: 사운드 파일 이름 (확장자 제외)
    /// - Parameter fileExtension: 파일 확장자 (예: "mp3", "wav")
    func playCustomSound(fileName: String, fileExtension: String = "mp3") {
        guard isEnabled else { return }
        
        // 기존 플레이어가 있으면 재사용
        if let player = audioPlayers[fileName] {
            player.currentTime = 0
            player.play()
            return
        }
        
        // 번들에서 사운드 파일 찾기
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("사운드 파일을 찾을 수 없습니다: \(fileName).\(fileExtension)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            audioPlayers[fileName] = player
        } catch {
            print("사운드 재생 실패: \(error)")
        }
    }
}
