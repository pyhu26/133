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

    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var timer: Timer?

    init(todo: TodoItem, isPresented: Binding<Bool>) {
        self.todo = todo
        self._isPresented = isPresented
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
                                .monospacedDigit()
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
        }
    }

    // MARK: - Timer Functions

    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                completeTask()
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        timeRemaining = totalSeconds
    }

    private func completeTask() {
        stopTimer()
        // 완료 처리 로직 추가 가능
        isPresented = false
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
        isPresented: .constant(true)
    )
}
