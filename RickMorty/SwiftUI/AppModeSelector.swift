//
//  AppModeSelector.swift
//  RickMorty
//

import SwiftUI

struct AppModeSelector: View {
    @AppStorage("useSwiftUI") private var useSwiftUI = true
    @AppStorage("hasSelectedMode") private var hasSelectedMode = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 44))
                    .foregroundStyle(Theme.accentSwiftUI)

                Text("Rick and Morty")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(.label))

                Text("Choose your interface")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                modeCard(
                    title: "SwiftUI",
                    subtitle: "Modern declarative UI",
                    icon: "swift",
                    isSelected: true
                ) {
                    useSwiftUI = true
                    hasSelectedMode = true
                }

                modeCard(
                    title: "UIKit",
                    subtitle: "Classic imperative UI",
                    icon: "hammer.fill",
                    isSelected: false
                ) {
                    useSwiftUI = false
                    hasSelectedMode = true
                }
            }
            .padding(.horizontal, 32)

            Text("You can change this later in Settings")
                .font(.system(size: 13))
                .foregroundStyle(.tertiary)

            Spacer()
        }
        .background(Color(.systemBackground))
    }

    private func modeCard(title: String, subtitle: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.accentSwiftUI)
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.label))
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title): \(subtitle)")
    }
}
