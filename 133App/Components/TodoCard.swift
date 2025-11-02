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
        .background(Color.white)
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
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

// MARK: - Checkbox View

struct CheckboxView: View {
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
    .background(Color.lightWarmGray)
}
