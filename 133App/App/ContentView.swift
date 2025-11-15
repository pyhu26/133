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

    var body: some View {
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
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
