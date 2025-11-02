//
//  HomeView.swift
//  133App
//
//  홈 화면 - 오늘의 할 일 관리
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = TodoViewModel()
    @State private var showAddTodo = false
    @State private var showTimer = false
    @State private var selectedTodo: TodoItem?

    var body: some View {
        ZStack {
            // Background
            Color.lightWarmGray
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Greeting Header
                    GreetingHeaderView(viewModel: viewModel)
                        .padding(.top, Spacing.screenTop)

                    // Todo List
                    TodoListView(
                        viewModel: viewModel,
                        onTodoTap: { todo in
                            selectedTodo = todo
                            showTimer = true
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
                    EncouragementCard(message: viewModel.getEncouragementMessage())

                    Spacer(minLength: Spacing.screenBottom)
                }
                .padding(.horizontal, Spacing.screenHorizontal)
            }
        }
        .sheet(isPresented: $showAddTodo) {
            AddTodoView(viewModel: viewModel, isPresented: $showAddTodo)
        }
        .fullScreenCover(isPresented: $showTimer) {
            if let todo = selectedTodo {
                TimerView(todo: todo, isPresented: $showTimer)
            }
        }
    }
}

// MARK: - Greeting Header View

struct GreetingHeaderView: View {
    var viewModel: TodoViewModel

    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: Spacing.xs) {
                Text(viewModel.getGreeting().icon)
                    .font(.system(size: 28))

                Text(viewModel.getGreeting().message)
                    .textStyle(.headingLarge)
            }

            Text(viewModel.getGreeting().subtitle)
                .textStyle(.bodySmall)
                .foregroundColor(.mediumGray)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Todo List View

struct TodoListView: View {
    var viewModel: TodoViewModel
    let onTodoTap: (TodoItem) -> Void

    var body: some View {
        VStack(spacing: Spacing.md) {
            ForEach(viewModel.todos) { todo in
                TodoCard(todo: todo) {
                    viewModel.toggleComplete(todo)
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
            .fill(Color.white.opacity(0.5))
            .frame(height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.borderGray, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
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
                Color.warmBeige
                    .opacity(0.6)
            )
            .largeRadius()
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
