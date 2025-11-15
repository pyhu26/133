//
//  EditTodoView.swift
//  133App
//
//  할 일 편집 화면
//

import SwiftUI

struct EditTodoView: View {
    @Bindable var viewModel: TodoViewModel
    let todo: TodoItem
    @Binding var isPresented: Bool

    @State private var todoTitle: String
    @State private var selectedMinutes: Int
    @State private var memo: String
    @FocusState private var isTitleFocused: Bool

    let timeOptions = [3, 5, 10, 15, 20, 30]

    init(viewModel: TodoViewModel, todo: TodoItem, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.todo = todo
        self._isPresented = isPresented
        self._todoTitle = State(initialValue: todo.title)
        self._selectedMinutes = State(initialValue: todo.estimatedMinutes)
        self._memo = State(initialValue: todo.memo ?? "")
    }

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
                        Text("할 일 수정")
                            .textStyle(.headingMedium)

                        Text("내용을 수정하세요")
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
                            title: "저장하기",
                            icon: "checkmark.circle.fill",
                            style: .primary
                        ) {
                            saveTodo()
                        }
                        .disabled(todoTitle.isEmpty)

                        CustomButton(
                            title: "취소",
                            style: .text
                        ) {
                            isPresented = false
                        }
                    }

                    // Info
                    Text("완료된 할일은 수정할 수 없어요")
                        .textStyle(.caption)
                        .foregroundColor(.adaptiveSecondaryText)
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

    private func saveTodo() {
        guard !todoTitle.isEmpty else { return }

        viewModel.updateTodo(
            todo,
            title: todoTitle,
            estimatedMinutes: selectedMinutes,
            memo: memo.isEmpty ? nil : memo
        )

        HapticManager.shared.success()
        isPresented = false
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
        EditTodoView(
            viewModel: TodoViewModel(),
            todo: TodoItem.sample1,
            isPresented: .constant(true)
        )
    }
}
