//
//  TodoCard.swift
//  133App
//
//  할 일 카드 컴포넌트
//

import SwiftUI

struct TodoCard: View {
    let todo: TodoItem
    let onToggle: () -> Void
    var onTap: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    @State private var isPressed = false

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Checkbox
            CheckboxView(isChecked: todo.isCompleted) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    onToggle()
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.title)
                    .textStyle(.bodyLarge)
                    .strikethrough(todo.isCompleted, color: .mediumGray)
                    .foregroundColor(todo.isCompleted ? .mediumGray : .deepWarmGray)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))

                    Text("\(todo.estimatedMinutes)분")
                        .textStyle(.caption)
                }
                .foregroundColor(.mediumGray)

                if let memo = todo.memo, !memo.isEmpty {
                    Text(memo)
                        .textStyle(.captionSmall)
                        .foregroundColor(.lightGray)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding(Spacing.cardInternal)
        .background(Color.adaptiveCardBackground)
        .largeRadius()
        .lightShadow()
        .overlay(
            // Left accent border (hover state)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardAccentGradient)
                .frame(width: 4)
                .opacity(isPressed ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: isPressed),
            alignment: .leading
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .opacity(todo.isCompleted ? 0.6 : 1.0)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // 삭제 버튼
            Button(role: .destructive) {
                HapticManager.shared.medium()
                onDelete?()
            } label: {
                Label("삭제", systemImage: "trash")
            }
            
            // 편집 버튼
            if !todo.isCompleted {
                Button {
                    HapticManager.shared.light()
                    onEdit?()
                } label: {
                    Label("편집", systemImage: "pencil")
                }
                .tint(.orange)
            }
        }
        .onTapGesture {
            print("🎯 Card tapped: \(todo.title), isCompleted: \(todo.isCompleted)")
            guard !todo.isCompleted else {
                print("⚠️ Todo is completed, ignoring tap")
                return
            }
            
            // 햅틱 피드백
            HapticManager.shared.light()
            
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                print("✅ Calling onTap closure")
                onTap?()
            }
        }
    }
}

// MARK: - Checkbox View

struct CheckboxView: View {
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            // 햅틱 피드백 & 사운드
            HapticManager.shared.checkboxToggle()
            SoundManager.shared.playCheck()
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.softPeach, lineWidth: 2.5)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isChecked ? Color.softPeach : Color.clear)
                    )

                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        TodoCard(
            todo: TodoItem.sample1,
            onToggle: {}
        )

        TodoCard(
            todo: TodoItem(
                title: "물 한 잔 마시기",
                estimatedMinutes: 3,
                isCompleted: true
            ),
            onToggle: {}
        )
    }
    .padding()
    .background(Color.adaptiveBackground)
}
