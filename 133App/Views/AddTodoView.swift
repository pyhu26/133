//
//  AddTodoView.swift
//  133App
//
//  할 일 추가 화면 (Bottom Sheet)
//

import SwiftUI

struct AddTodoView: View {
    @Bindable var viewModel: TodoViewModel
    @Binding var isPresented: Bool

    @State private var todoTitle: String = ""
    @State private var selectedMinutes: Int = 3
    @State private var memo: String = ""
    @FocusState private var isTitleFocused: Bool

    let timeOptions = [3, 5, 10, 15, 20, 30]

    var body: some View {
        ZStack {
            // Background dimmed overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 0) {
                Spacer()

                // Bottom Sheet Container
                VStack(spacing: Spacing.xl) {
                    // Handle Bar
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.adaptiveTertiaryText)
                        .frame(width: 36, height: 4)
                        .padding(.top, Spacing.md)

                    // Header
                    VStack(spacing: Spacing.xs) {
                        Text("새로운 할 일")
                            .textStyle(.headingMedium)

                        Text("오늘 하고 싶은 일을 적어보세요")
                            .textStyle(.bodySmall)
                            .foregroundColor(.adaptiveSecondaryText)
                    }

                    // Form
                    VStack(spacing: Spacing.xl) {
                        // Todo Title Input
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("할 일")
                                .textStyle(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)

                            TextField("예: 아침 스트레칭하기", text: $todoTitle)
                                .textStyle(.bodyRegular)
                                .padding(Spacing.md)
                                .background(Color.adaptiveInputBackground)
                                .mediumRadius()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            isTitleFocused ? Color.softPeach : Color.adaptiveBorder,
                                            lineWidth: 2
                                        )
                                )
                                .lightShadow()
                                .focused($isTitleFocused)
                        }

                        // Time Selector
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("예상 시간")
                                .textStyle(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: 3), spacing: Spacing.sm) {
                                ForEach(timeOptions, id: \.self) { minutes in
                                    TimeOptionButton(
                                        minutes: minutes,
                                        isSelected: selectedMinutes == minutes
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedMinutes = minutes
                                        }
                                    }
                                }
                            }
                        }

                        // Memo Input (Optional)
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("메모 (선택)")
                                .textStyle(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)

                            TextField("간단한 메모를 남겨보세요", text: $memo, axis: .vertical)
                                .textStyle(.bodySmall)
                                .lineLimit(2...4)
                                .padding(Spacing.md)
                                .background(Color.adaptiveInputBackground)
                                .mediumRadius()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.adaptiveBorder, lineWidth: 1.5)
                                )
                        }
                    }

                    // Buttons
                    VStack(spacing: Spacing.sm) {
                        CustomButton(
                            title: "추가하기",
                            icon: "checkmark.circle.fill",
                            style: .primary
                        ) {
                            addTodo()
                        }
                        .disabled(todoTitle.isEmpty)

                        CustomButton(
                            title: "취소",
                            style: .text
                        ) {
                            isPresented = false
                        }
                    }

                    // Encouragement
                    Text("3분만 집중해도 충분해요!")
                        .textStyle(.caption)
                        .foregroundColor(.softPeach)
                }
                .padding(Spacing.xl)
                .background(
                    Color.adaptiveSecondaryBackground
                        .clipShape(
                            .rect(
                                topLeadingRadius: 24,
                                topTrailingRadius: 24
                            )
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 20, y: -5)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            isTitleFocused = true
        }
    }

    private func addTodo() {
        guard !todoTitle.isEmpty else { return }

        viewModel.addTodo(
            title: todoTitle,
            estimatedMinutes: selectedMinutes,
            memo: memo.isEmpty ? nil : memo
        )

        isPresented = false
    }
}

// MARK: - Time Option Button

struct TimeOptionButton: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(minutes)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                Text("분")
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .adaptiveText)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(
                Group {
                    if isSelected {
                        Color.peachGradient
                    } else {
                        Color.adaptiveInputBackground
                    }
                }
            )
            .mediumRadius()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : Color.adaptiveBorder, lineWidth: 2)
            )
            .applyShadow(style: isSelected ? .primary : .secondary)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.adaptiveBackground
            .ignoresSafeArea()

        Text("Home Screen")
            .font(.largeTitle)
    }
    .sheet(isPresented: .constant(true)) {
        AddTodoView(
            viewModel: TodoViewModel(),
            isPresented: .constant(true)
        )
    }
}
