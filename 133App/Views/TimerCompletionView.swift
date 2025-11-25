//
//  TimerCompletionView.swift
//  133App
//
//  타이머 완료 축하 화면
//

import SwiftUI

struct TimerCompletionView: View {
    let todo: TodoItem
    let actualMinutes: Int
    @Binding var isPresented: Bool
    
    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var messageOffset: CGFloat = 50
    
    private let messages = [
        "해냈어! 너 정말 멋져! 🎉",
        "좋아, 시작이 반이야! 💪",
        "오늘 너, 어제와 달라! ✨",
        "완벽해! 집중 완료! 🌟",
        "잘했어! 계속 가자! 🚀"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                // Confetti
                if showConfetti {
                    ConfettiView()
                        .ignoresSafeArea()
                }

                // Main Content
                VStack(spacing: Spacing.xl) {
                    Spacer()

                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.softPeach, .gentleLavender],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.softPeach.opacity(0.5), radius: 20, y: 10)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)

                    // Todo Title
                    Text(todo.title)
                        .textStyle(.headingLarge)
                        .foregroundColor(.adaptiveText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                        .scaleEffect(scale)
                        .opacity(opacity)

                    // Time Info
                    VStack(spacing: Spacing.sm) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.softPeach)

                            Text("집중 시간")
                                .textStyle(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)
                        }

                        Text("\(actualMinutes)분")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.softPeach)
                    }
                    .padding(.vertical, Spacing.lg)
                    .padding(.horizontal, Spacing.xl)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.adaptiveCardBackground)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                    )
                    .scaleEffect(scale)
                    .opacity(opacity)

                    // Encouragement Message
                    Text(randomMessage)
                        .textStyle(.headingMedium)
                        .foregroundColor(.adaptiveText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xl)
                        .offset(y: messageOffset)
                        .opacity(opacity)

                    Spacer()

                    // Close Button
                    CustomButton(
                        title: "완료",
                        icon: "checkmark",
                        style: .primary
                    ) {
                        closeView()
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, Spacing.screenBottom))
                    .opacity(opacity)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private var randomMessage: String {
        messages.randomElement() ?? messages[0]
    }
    
    private func startAnimations() {
        // Haptic feedback
        HapticManager.shared.celebration()
        
        // Sound
        SoundManager.shared.playComplete()
        
        // Confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showConfetti = true
        }
        
        // Icon animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Message animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
            messageOffset = 0
        }
    }
    
    private func closeView() {
        HapticManager.shared.light()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Preview

#Preview {
    TimerCompletionView(
        todo: TodoItem.sample1,
        actualMinutes: 3,
        isPresented: .constant(true)
    )
}
