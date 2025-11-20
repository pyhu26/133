//
//  LaunchView.swift
//  133App
//
//  런치 스크린
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            // 배경색 (이미지 여백 부분)
            Color.white
                .ignoresSafeArea()

            Image("launch_bg") // 이미지에 글자 포함됨
                .resizable()
                .scaledToFit() // 이미지 전체가 보이도록 변경
                .ignoresSafeArea()

            // 이미지에 글자가 포함되어 있어서 주석처리
//            VStack(spacing: 12) {
//                Text("133")
//                    .font(.system(size: 56, weight: .thin))
//                    .foregroundColor(.white)
//                    .shadow(color: Color.white.opacity(0.4), radius: 10)
//
//                Text("하루에 3개, 3분만 해도 충분해\n작은 변화가 곧 다른 세계야")
//                    .font(.system(size: 15, weight: .thin))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white.opacity(0.85))
//                    .shadow(color: Color.black.opacity(0.1), radius: 4)
//            }
//            .padding(.bottom, 120)
        }
    }
}

// MARK: - Preview

#Preview {
    LaunchView()
}
