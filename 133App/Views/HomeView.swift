//
//  HomeView.swift
//  133App
//
//  홈 화면 - 오늘의 할 일 관리
//

import SwiftUI

struct HomeView: View {
    @Environment(TodoViewModel.self) private var viewModel
    @Environment(SettingsManager.self) private var settingsManager
    @State private var showAddTodo = false
    @State private var showTimer = false
    @State private var selectedTodo: TodoItem?
    @State private var showEditTodo = false
    @State private var editingTodo: TodoItem?
    @State private var showDeleteAlert = false
    @State private var deletingTodo: TodoItem?

    var body: some View {
        ZStack {
            // Background
            Color.adaptiveBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Greeting Header
                    GreetingHeaderView(
                        viewModel: viewModel,
                        userName: settingsManager.userName
                    )
                        .padding(.top, Spacing.screenTop)

                    // Todo List
                    TodoListView(
                        viewModel: viewModel,
                        onTodoTap: { todo in
                            print("🔔 Todo tapped: \(todo.title)")
                            selectedTodo = todo
                            showTimer = true
                            print("🔔 showTimer set to true, selectedTodo: \(selectedTodo?.title ?? "nil")")
                        },
                        onTodoEdit: { todo in
                            editingTodo = todo
                            showEditTodo = true
                        },
                        onTodoDelete: { todo in
                            deletingTodo = todo
                            showDeleteAlert = true
                        }
                    )

                    // Add Button
                    if viewModel.canAddMore {
                        AddTodoButton(
                            remainingSlots: viewModel.remainingSlots,
                            action: {
                                showAddTodo = true
                            }
                        )
                    }

                    // Encouragement Card
                    if settingsManager.encouragementEnabled {
                        EncouragementCard(message: viewModel.getEncouragementMessage())
                    }

                    Spacer(minLength: Spacing.screenBottom)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
        .onAppear {
            // 개발용: 할일이 없으면 샘플 데이터 로드
            if viewModel.todos.isEmpty {
                print("📝 Loading sample data...")
                viewModel.loadSampleData()
            }
        }
        .sheet(isPresented: $showAddTodo) {
            AddTodoView(viewModel: viewModel, isPresented: $showAddTodo)
        }
        .sheet(isPresented: $showEditTodo) {
            if let todo = editingTodo {
                EditTodoView(viewModel: viewModel, todo: todo, isPresented: $showEditTodo)
            }
        }
        .alert("할일 삭제", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                if let todo = deletingTodo {
                    withAnimation {
                        viewModel.deleteTodo(todo)
                    }
                    HapticManager.shared.success()
                }
            }
        } message: {
            if let todo = deletingTodo {
                Text("'\(todo.title)'을(를) 삭제하시겠습니까?")
            }
        }
        .fullScreenCover(isPresented: $showTimer) {
            if let todo = selectedTodo {
                TimerView(
                    todo: todo,
                    isPresented: $showTimer,
                    onComplete: { completedTodo, actualMinutes in
                        print("✅ Task completed: \(completedTodo.title), actual time: \(actualMinutes) minutes")
                        viewModel.completeTodo(completedTodo, actualMinutes: actualMinutes)
                    }
                )
                .onAppear {
                    print("🚀 TimerView appeared with todo: \(todo.title)")
                }
            } else {
                Text("No todo selected")
                    .foregroundColor(.red)
                    .onAppear {
                        print("❌ No todo selected!")
                    }
            }
        }
        .onChange(of: showTimer) { oldValue, newValue in
            print("📊 showTimer changed from \(oldValue) to \(newValue)")
        }
    }
}

// MARK: - Greeting Header View

struct GreetingHeaderView: View {
    var viewModel: TodoViewModel
    var userName: String

    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: Spacing.xs) {
                Text(viewModel.getGreeting(userName: userName).icon)
                    .font(.system(size: 28))

                Text(viewModel.getGreeting(userName: userName).message)
                    .textStyle(.headingLarge)
            }

            Text(viewModel.getGreeting(userName: userName).subtitle)
                .textStyle(.bodySmall)
                .foregroundColor(.adaptiveSecondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Todo List View

struct TodoListView: View {
    var viewModel: TodoViewModel
    let onTodoTap: (TodoItem) -> Void
    let onTodoEdit: (TodoItem) -> Void
    let onTodoDelete: (TodoItem) -> Void

    var body: some View {
        VStack(spacing: Spacing.md) {
            ForEach(viewModel.todos) { todo in
                TodoCard(todo: todo) {
                    viewModel.toggleComplete(todo)
                } onTap: {
                    onTodoTap(todo)
                } onEdit: {
                    onTodoEdit(todo)
                } onDelete: {
                    onTodoDelete(todo)
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }

            // Empty slots
            ForEach(0..<viewModel.remainingSlots, id: \.self) { _ in
                EmptyTodoSlot()
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.todos.count)
    }
}

// MARK: - Empty Todo Slot

struct EmptyTodoSlot: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.adaptiveCardBackground.opacity(0.5))
            .frame(height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.adaptiveBorder, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
            )
    }
}

// MARK: - Add Todo Button

struct AddTodoButton: View {
    let remainingSlots: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                // Plus Icon Circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 24, height: 24)

                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }

                Text("할 일 추가하기")
                    .textStyle(.buttonText)
                    .foregroundColor(.white)

                Spacer()

                Text("\(3 - remainingSlots)/3")
                    .textStyle(.captionSmall)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(Spacing.cardInternal)
            .background(Color.peachGradient)
            .largeRadius()
            .accentShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Encouragement Card

struct EncouragementCard: View {
    let message: String

    var body: some View {
        Text(message)
            .textStyle(.bodyLarge)
            .foregroundColor(.softPeach)
            .frame(maxWidth: .infinity)
            .padding(Spacing.cardInternal)
            .background(
                Color.adaptiveSecondaryBackground
                    .opacity(0.6)
            )
            .largeRadius()
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
