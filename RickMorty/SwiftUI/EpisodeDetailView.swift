//
//  EpisodeDetailView.swift
//  RickMorty
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: RMEpisode
    @State private var isFavorite: Bool

    init(episode: RMEpisode) {
        self.episode = episode
        _isFavorite = State(initialValue: FavoritesManager.shared.isEpisodeFavorite(episode.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Episode code badge
                Text(episode.episode)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Theme.accentSwiftUI)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 20)

                HStack {
                    Spacer()
                    Text(episode.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    favoriteButton
                        .padding(.trailing, 4)
                }

                VStack(spacing: 12) {
                    InfoRowView(title: "Air Date", value: episode.airDate)
                    InfoRowView(title: "Episode Code", value: episode.episode)
                    InfoRowView(title: "Characters", value: "\(episode.characters.count) character(s)")
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggleEpisode(episode.id)
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}
