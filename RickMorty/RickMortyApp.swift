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

    var body: some Scene {
        WindowGroup {
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
}

struct MainTabBarRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        return MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}
