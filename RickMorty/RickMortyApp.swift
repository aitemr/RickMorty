//
//  RickMortyApp.swift
//  RickMorty
//
//  Created by Islam Temirbek on 19.05.2026.
//

import SwiftUI
import UIKit

@main
struct RickMortyApp: App {
    @AppStorage("hasSelectedMode") private var hasSelectedMode = false
    @AppStorage("useSwiftUI") private var useSwiftUI = true
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                mainContent

                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        if !hasSelectedMode {
            AppModeSelector()
        } else if useSwiftUI {
            SwiftUIMainTabView()
        } else {
            MainTabBarRepresentable()
                .ignoresSafeArea()
        }
    }
}

struct MainTabBarRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        return MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}
