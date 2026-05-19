//
//  SettingsView.swift
//  RickMorty
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("useSwiftUI") private var useSwiftUI = true
    private var loc = LocalizationManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section(loc.string("settings.interface")) {
                    HStack {
                        settingsIcon("paintbrush.fill", color: .purple)
                        Text(loc.string("settings.uiMode"))
                        Spacer()
                        Text(useSwiftUI ? "SwiftUI" : "UIKit")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("\(loc.string("settings.uiMode")): \(useSwiftUI ? "SwiftUI" : "UIKit")")

                    Button {
                        useSwiftUI.toggle()
                    } label: {
                        HStack {
                            settingsIcon("arrow.triangle.2.circlepath", color: Theme.accentSwiftUI)
                            Text("\(loc.string("settings.switchTo")) \(useSwiftUI ? "UIKit" : "SwiftUI")")
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Picker(selection: Bindable(loc).language) {
                        Text("English").tag("en")
                        Text("Русский").tag("ru")
                    } label: {
                        HStack {
                            settingsIcon("globe", color: .cyan)
                            Text(loc.string("settings.language"))
                        }
                    }
                }

                Section(loc.string("settings.general")) {
                    Button {
                        shareApp()
                    } label: {
                        HStack {
                            settingsIcon("square.and.arrow.up", color: .blue)
                            Text(loc.string("settings.shareApp"))
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Button {
                        requestReview()
                    } label: {
                        HStack {
                            settingsIcon("star.fill", color: .yellow)
                            Text(loc.string("settings.rateUs"))
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Button {
                        shareApp()
                    } label: {
                        HStack {
                            settingsIcon("heart.fill", color: .pink)
                            Text(loc.string("settings.supportUs"))
                                .foregroundStyle(Color(.label))
                        }
                    }
                }

                Section(loc.string("settings.information")) {
                    Link(destination: URL(string: "https://rickandmortyapi.com/about")!) {
                        HStack {
                            settingsIcon("lock.shield.fill", color: .green)
                            Text(loc.string("settings.privacyPolicy"))
                                .foregroundStyle(Color(.label))
                        }
                    }

                    Link(destination: URL(string: "mailto:support@rickandmorty.app")!) {
                        HStack {
                            settingsIcon("envelope.fill", color: .orange)
                            Text(loc.string("settings.contactUs"))
                                .foregroundStyle(Color(.label))
                        }
                    }

                    HStack {
                        settingsIcon("info.circle.fill", color: .gray)
                        Text(loc.string("settings.appVersion"))
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(loc.string("settings.title"))
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
