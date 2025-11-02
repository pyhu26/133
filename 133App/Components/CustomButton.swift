//
//  CustomButton.swift
//  133App
//
//  커스텀 버튼 컴포넌트
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyleType
    let action: () -> Void

    @State private var isPressed = false

    init(
        title: String,
        icon: String? = nil,
        style: ButtonStyleType = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: {
            isPressed = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                }

                Text(title)
                    .textStyle(.buttonText)
            }
            .foregroundColor(style.textColor)
            .padding(.horizontal, style.horizontalPadding)
            .padding(.vertical, style.verticalPadding)
            .frame(maxWidth: style.isFullWidth ? .infinity : nil)
            .background(style.background)
            .mediumRadius()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .applyShadow(style: style)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .disabled(style == .disabled)
    }
}

// MARK: - Button Style Type

enum ButtonStyleType {
    case primary
    case secondary
    case text
    case disabled

    var background: AnyView {
        switch self {
        case .primary:
            return AnyView(Color.peachGradient)
        case .secondary:
            return AnyView(Color.white)
        case .text:
            return AnyView(Color.clear)
        case .disabled:
            return AnyView(Color.lightGray)
        }
    }

    var textColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .deepWarmGray
        case .text:
            return .softPeach
        case .disabled:
            return .mediumGray
        }
    }

    var borderColor: Color {
        switch self {
        case .secondary:
            return .borderGray
        default:
            return .clear
        }
    }

    var borderWidth: CGFloat {
        self == .secondary ? 1.5 : 0
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .text:
            return 12
        default:
            return 32
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .text:
            return 8
        default:
            return 16
        }
    }

    var isFullWidth: Bool {
        switch self {
        case .primary, .secondary:
            return true
        case .text, .disabled:
            return false
        }
    }
}

// MARK: - Shadow Extension for Button

extension View {
    func applyShadow(style: ButtonStyleType) -> some View {
        Group {
            if style == .primary {
                self.accentShadow()
            } else if style == .secondary {
                self.lightShadow()
            } else {
                self
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        CustomButton(
            title: "할 일 추가하기",
            icon: "plus.circle.fill",
            style: .primary,
            action: {}
        )

        CustomButton(
            title: "취소",
            style: .secondary,
            action: {}
        )

        CustomButton(
            title: "더보기",
            style: .text,
            action: {}
        )

        CustomButton(
            title: "비활성화",
            style: .disabled,
            action: {}
        )
    }
    .padding()
    .background(Color.lightWarmGray)
}
