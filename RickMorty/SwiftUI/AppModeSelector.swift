//
//  AppModeSelector.swift
//  RickMorty
//

import SwiftUI

struct AppModeSelector: View {
    @AppStorage("useSwiftUI") private var useSwiftUI = true
    @AppStorage("hasSelectedMode") private var hasSelectedMode = false
    private var loc = LocalizationManager.shared

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 44))
                    .foregroundStyle(Theme.accentSwiftUI)

                Text(loc.string("modeSelector.title"))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(.label))

                Text(loc.string("modeSelector.subtitle"))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                modeCard(
                    title: loc.string("modeSelector.swiftui"),
                    subtitle: loc.string("modeSelector.swiftui.desc"),
                    icon: "swift",
                    isSelected: true
                ) {
                    useSwiftUI = true
                    hasSelectedMode = true
                }

                modeCard(
                    title: loc.string("modeSelector.uikit"),
                    subtitle: loc.string("modeSelector.uikit.desc"),
                    icon: "hammer.fill",
                    isSelected: false
                ) {
                    useSwiftUI = false
                    hasSelectedMode = true
                }
            }
            .padding(.horizontal, 32)

            Text(loc.string("modeSelector.changeLater"))
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
