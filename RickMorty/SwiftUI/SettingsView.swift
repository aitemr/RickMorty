//
//  SettingsView.swift
//  RickMorty
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("useSwiftUI") private var useSwiftUI = true

    var body: some View {
        NavigationStack {
            List {
                Section("Interface") {
                    HStack {
                        settingsIcon("paintbrush.fill", color: .purple)
                        Text("UI Mode")
                        Spacer()
                        Text(useSwiftUI ? "SwiftUI" : "UIKit")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("UI Mode: \(useSwiftUI ? "SwiftUI" : "UIKit")")

                    Button {
                        useSwiftUI.toggle()
                    } label: {
                        HStack {
                            settingsIcon("arrow.triangle.2.circlepath", color: Theme.accentSwiftUI)
                            Text("Switch to \(useSwiftUI ? "UIKit" : "SwiftUI")")
                                .foregroundStyle(Color(.label))
                        }
                    }
                }

                Section("General") {
                    Button {
                        shareApp()
                    } label: {
                        HStack {
                            settingsIcon("square.and.arrow.up", color: .blue)
                            Text("Share App")
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Button {
                        requestReview()
                    } label: {
                        HStack {
                            settingsIcon("star.fill", color: .yellow)
                            Text("Rate Us")
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Button {
                        shareApp()
                    } label: {
                        HStack {
                            settingsIcon("heart.fill", color: .pink)
                            Text("Support Us")
                                .foregroundStyle(Color(.label))
                        }
                    }
                }

                Section("Information") {
                    Link(destination: URL(string: "https://rickandmortyapi.com/about")!) {
                        HStack {
                            settingsIcon("lock.shield.fill", color: .green)
                            Text("Privacy Policy")
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Link(destination: URL(string: "mailto:support@rickandmorty.app")!) {
                        HStack {
                            settingsIcon("envelope.fill", color: .orange)
                            Text("Contact Us")
                                .foregroundStyle(Color(.label))
                        }
                    }

                    HStack {
                        settingsIcon("info.circle.fill", color: .gray)
                        Text("App Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func settingsIcon(_ systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .foregroundStyle(color)
            .frame(width: 28)
    }

    private func shareApp() {
        let text = "Check out The Rick and Morty Dimension Guide!"
        guard let url = URL(string: "https://rickandmortyapi.com") else { return }
        let activityVC = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
