//
//  ConfettiView.swift
//  133App
//
//  Confetti 애니메이션 효과
//

import SwiftUI

struct ConfettiView: View {
    @State private var isAnimating = false
    let confettiCount = 50
    
    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiPiece(
                    index: index,
                    isAnimating: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Confetti Piece

struct ConfettiPiece: View {
    let index: Int
    let isAnimating: Bool
    
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    
    private let colors: [Color] = [
        .softPeach,
        .gentleLavender,
        .softMint,
        .powderBlue,
        .paleYellow,
        .warmBeige
    ]
    
    private let shapes = ["circle", "square", "triangle"]
    
    var body: some View {
        confettiShape
            .frame(width: randomSize, height: randomSize)
            .foregroundColor(randomColor)
            .position(position)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .onAppear {
                startAnimation()
            }
    }
    
    private var confettiShape: some View {
        Group {
            switch shapes[index % shapes.count] {
            case "circle":
                Circle()
            case "square":
                Rectangle()
            case "triangle":
                Triangle()
            default:
                Circle()
            }
        }
    }
    
    private var randomColor: Color {
        colors[index % colors.count]
    }
    
    private var randomSize: CGFloat {
        CGFloat.random(in: 8...16)
    }
    
    private var startX: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return CGFloat.random(in: 0...screenWidth)
    }
    
    private var startY: CGFloat {
        -50
    }
    
    private var endY: CGFloat {
        UIScreen.main.bounds.height + 100
    }
    
    private var randomDelay: Double {
        Double.random(in: 0...0.5)
    }
    
    private var randomDuration: Double {
        Double.random(in: 2...4)
    }
    
    private var randomXOffset: CGFloat {
        CGFloat.random(in: -100...100)
    }
    
    private func startAnimation() {
        position = CGPoint(x: startX, y: startY)
        
        withAnimation(
            .easeOut(duration: randomDuration)
            .delay(randomDelay)
        ) {
            position = CGPoint(
                x: startX + randomXOffset,
                y: endY
            )
            opacity = 0
        }
        
        withAnimation(
            .linear(duration: randomDuration)
            .repeatForever(autoreverses: false)
            .delay(randomDelay)
        ) {
            rotation = 360 * Double.random(in: 2...5)
        }
        
        withAnimation(
            .easeInOut(duration: randomDuration / 2)
            .repeatForever(autoreverses: true)
            .delay(randomDelay)
        ) {
            scale = CGFloat.random(in: 0.5...1.5)
        }
    }
}

// MARK: - Triangle Shape

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.lightWarmGray
            .ignoresSafeArea()
        
        ConfettiView()
    }
}
