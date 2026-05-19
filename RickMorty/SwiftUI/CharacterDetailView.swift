//
//  CharacterDetailView.swift
//  RickMorty
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    @State private var isFavorite: Bool

    init(character: RMCharacter) {
        self.character = character
        _isFavorite = State(initialValue: FavoritesManager.shared.isCharacterFavorite(character.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero image
                ZStack(alignment: .topLeading) {
                    CachedAsyncImage(urlString: character.image)
                        .frame(height: 340)
                        .clipped()

                    HStack {
                        statusBadge
                        Spacer()
                        favoriteButton
                    }
                    .padding(16)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(character.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(.label))

                    InfoRowView(title: "Species", value: character.species)
                    InfoRowView(title: "Gender", value: character.gender)
                    InfoRowView(title: "Origin", value: character.origin.name)
                    InfoRowView(title: "Location", value: character.location.name)
                    InfoRowView(title: "Episodes", value: "\(character.episode.count) episode(s)")
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var statusBadge: some View {
        Text(character.status.rawValue.uppercased())
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor)
            .clipShape(Capsule())
    }

    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggleCharacter(character.id)
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
