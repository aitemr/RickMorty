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
    var body: some Scene {
        WindowGroup {
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
