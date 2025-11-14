//
//  TimerView.swift
//  133App
//
//  집중 타이머 화면
//

import SwiftUI

struct TimerView: View {
    let todo: TodoItem
    @Binding var isPresented: Bool
    var onComplete: ((TodoItem, Int) -> Void)?

    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var elapsedSeconds: Int = 0
    
    // 백그라운드 타이머 지원을 위한 변수들
    @State private var sessionStartTime: Date?
    @State private var pausedTime: Date?
    @State private var totalPausedDuration: TimeInterval = 0
    
    // 완료 축하 화면
    @State private var showCompletionView = false
    @State private var completedActualMinutes: Int = 0
    
    // 알림 관리자
    private let notificationManager = NotificationManager.shared

    init(todo: TodoItem, isPresented: Binding<Bool>, onComplete: ((TodoItem, Int) -> Void)? = nil) {
        self.todo = todo
        self._isPresented = isPresented
        self.onComplete = onComplete
        self._timeRemaining = State(initialValue: todo.estimatedMinutes * 60)
    }

    private var totalSeconds: Int {
        todo.estimatedMinutes * 60
    }

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - (Double(timeRemaining) / Double(totalSeconds))
    }

    private var minutes: Int {
        timeRemaining / 60
    }

    private var seconds: Int {
        timeRemaining % 60
    }

    private var encouragementMessage: String {
        if progress < 0.25 {
            return "좋아, 시작이 반이야!"
        } else if progress < 0.5 {
            return "잘하고 있어!"
        } else if progress < 0.75 {
            return "조금만 더 힘내!"
        } else if progress < 1.0 {
            return "거의 다 왔어!"
        } else {
            return "완료!"
        }
    }

    var body: some View {
        ZStack {
            // Animated Gradient Background
            AnimatedGradientBackground()
                .ignoresSafeArea()

            VStack(spacing: Spacing.xxxl) {
                // Close Button
                HStack {
                    Button(action: {
                        stopTimer()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .blur(radius: 10)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.top, 60)

                Spacer()

                // Todo Title
                Text(todo.title)
                    .textStyle(.headingLarge)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.screenHorizontal)

                // Progress Ring with Timer
                ZStack {
                    ProgressRing(
                        progress: progress,
                        size: 280,
                        lineWidth: 12
                    )

                    VStack(spacing: 8) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(String(format: "%02d:%02d", minutes, seconds))
                                .font(.timerLarge)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
                        }

                        if progress >= 1.0 {
                            Text("완료!")
                                .font(.timerUnit)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }

                // Encouragement Message
                Text(encouragementMessage)
                    .textStyle(.headingSmall)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, Spacing.screenHorizontal)

                Spacer()

                // Control Buttons
                HStack(spacing: Spacing.xl) {
                    // Reset Button
                    TimerControlButton(
                        icon: "arrow.counterclockwise",
                        isPrimary: false
                    ) {
                        resetTimer()
                    }

                    // Play/Pause Button
                    TimerControlButton(
                        icon: isRunning ? "pause.fill" : "play.fill",
                        isPrimary: true
                    ) {
                        if isRunning {
                            pauseTimer()
                        } else {
                            startTimer()
                        }
                    }

                    // Complete Button
                    TimerControlButton(
                        icon: "checkmark",
                        isPrimary: false
                    ) {
                        completeTask()
                    }
                }
                .padding(.bottom, 60)
            }
            
            // Completion Celebration View
            if showCompletionView {
                TimerCompletionView(
                    todo: todo,
                    actualMinutes: completedActualMinutes,
                    isPresented: $showCompletionView
                )
                .transition(.opacity)
                .zIndex(1)
                .onChange(of: showCompletionView) { oldValue, newValue in
                    if !newValue {
                        // 축하 화면이 닫힌 후 타이머 화면도 닫기
                        isPresented = false
                    }
                }
            }
        }
    }

    // MARK: - Timer Functions

    private func startTimer() {
        isRunning = true
        
        // 햅틱 & 사운드 피드백
        HapticManager.shared.timerStart()
        SoundManager.shared.playTimerStart()
        
        // 세션 시작 시간 기록
        if sessionStartTime == nil {
            sessionStartTime = Date()
        }
        
        // 일시정지에서 재개하는 경우
        if let paused = pausedTime {
            let pauseDuration = Date().timeIntervalSince(paused)
            totalPausedDuration += pauseDuration
            pausedTime = nil
        }
        
        // 백그라운드 알림 스케줄
        Task {
            await notificationManager.scheduleTimerCompletionNotification(
                todoTitle: todo.title,
                delay: TimeInterval(timeRemaining)
            )
        }
        
        // 타이머 시작
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimer()
        }
    }
    
    private func updateTimer() {
        guard let sessionStart = sessionStartTime else { return }
        
        // 실제 경과 시간 계산 (일시정지 시간 제외)
        let totalElapsed = Date().timeIntervalSince(sessionStart) - totalPausedDuration
        elapsedSeconds = Int(totalElapsed)
        
        // 남은 시간 계산
        let newTimeRemaining = totalSeconds - elapsedSeconds
        
        if newTimeRemaining > 0 {
            timeRemaining = newTimeRemaining
        } else {
            timeRemaining = 0
            completeTask()
        }
    }

    private func pauseTimer() {
        isRunning = false
        pausedTime = Date()
        timer?.invalidate()
        timer = nil
        
        // 햅틱 피드백
        HapticManager.shared.timerStop()
        
        // 알림 취소
        notificationManager.cancelTimerCompletionNotification()
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        pausedTime = nil
        
        // 알림 취소
        notificationManager.cancelTimerCompletionNotification()
    }

    private func resetTimer() {
        stopTimer()
        timeRemaining = totalSeconds
        elapsedSeconds = 0
        sessionStartTime = nil
        totalPausedDuration = 0
        pausedTime = nil
        
        // 햅틱 피드백
        HapticManager.shared.medium()
    }

    private func completeTask() {
        stopTimer()
        
        // 햅틱 & 사운드 피드백
        HapticManager.shared.timerComplete()
        SoundManager.shared.playTimerComplete()
        
        // 실제로 작업한 시간(분) 계산
        let actualMinutes = Int(ceil(Double(elapsedSeconds) / 60.0))
        completedActualMinutes = actualMinutes
        
        // 완료 콜백 호출
        onComplete?(todo, actualMinutes)
        
        // 축하 화면 표시
        showCompletionView = true
    }
    
    // MARK: - Background Support
    
    private func handleScenePhaseChange(oldPhase: ScenePhase, newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            // 백그라운드로 이동
            if isRunning {
                print("⚠️ App moved to background while timer is running")
            }
            
        case .active:
            // 포그라운드로 복귀
            if isRunning {
                print("✅ App returned to foreground, updating timer...")
                // 타이머 재시작 (정확한 시간으로 업데이트)
                timer?.invalidate()
                updateTimer() // 즉시 한 번 업데이트
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    updateTimer()
                }
                
                // 알림 재스케줄
                if timeRemaining > 0 {
                    Task {
                        await notificationManager.scheduleTimerCompletionNotification(
                            todoTitle: todo.title,
                            delay: TimeInterval(timeRemaining)
                        )
                    }
                }
            }
            
        case .inactive:
            // 전환 상태 (무시)
            break
            
        @unknown default:
            break
        }
    }
}

// MARK: - Timer Control Button

struct TimerControlButton: View {
    let icon: String
    let isPrimary: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: isPrimary ? 32 : 24, weight: .semibold))
                .foregroundColor(isPrimary ? .softPeach : .white)
                .frame(width: isPrimary ? 80 : 72, height: isPrimary ? 80 : 72)
                .background(
                    Circle()
                        .fill(
                            isPrimary ?
                            Color.white.opacity(0.9) :
                            Color.white.opacity(0.25)
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    Color.white.opacity(isPrimary ? 0 : 0.3),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: isPrimary ? Color.white.opacity(0.3) : Color.clear,
                            radius: 10,
                            y: 4
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Animated Gradient Background

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(hex: "FFB5A7"), location: animateGradient ? 0.0 : 0.2),
                .init(color: Color(hex: "FFC4B8"), location: 0.5),
                .init(color: Color(hex: "D4C5F9"), location: animateGradient ? 1.0 : 0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                animateGradient = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    TimerView(
        todo: TodoItem.sample1,
        isPresented: .constant(true),
        onComplete: { todo, actualMinutes in
            print("Preview: Completed \(todo.title) in \(actualMinutes) minutes")
        }
    )
}
