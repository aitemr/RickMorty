//
//  CharacterCardView.swift
//  RickMorty
//

import SwiftUI

struct CharacterCardView: View {
    let character: RMCharacter

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CachedAsyncImage(urlString: character.image)
                .frame(minHeight: 140)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.label))
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(character.status.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(character.name), \(character.status.rawValue)")
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
