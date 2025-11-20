//
//  ContentView.swift
//  133App
//
//  메인 컨텐츠 뷰 - Tab Navigation
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var settingsManager = SettingsManager()
    @State private var todoViewModel = TodoViewModel()
    @State private var showLaunchScreen = true

    var body: some View {
        ZStack {
            // Main TabView
            TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("홈")
                }
                .tag(0)

            // Stats Tab
            StatsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("통계")
                }
                .tag(1)

            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                    Text("설정")
                }
                .tag(2)
            }
            .accentColor(.softPeach)
            .environment(settingsManager)
            .environment(todoViewModel)
            .preferredColorScheme(settingsManager.darkModeEnabled ? .dark : .light)

            // Launch Screen Overlay
            if showLaunchScreen {
                LaunchView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            // 2초 후 런치 스크린 숨기기
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeOut(duration: 1.5)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
