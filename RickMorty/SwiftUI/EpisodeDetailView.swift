//
//  EpisodeDetailView.swift
//  RickMorty
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: RMEpisode
    @State private var isFavorite: Bool
    @State private var appeared = false

    init(episode: RMEpisode) {
        self.episode = episode
        _isFavorite = State(initialValue: FavoritesManager.shared.isEpisodeFavorite(episode.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Episode code badge with scale animation
                Text(episode.episode)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Theme.accentSwiftUI)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .scaleEffect(appeared ? 1.0 : 0.5)
                    .opacity(appeared ? 1 : 0)
                    .padding(.top, 30)

                HStack {
                    Spacer()
                    Text(episode.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .multilineTextAlignment(.center)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 15)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    favoriteButton
                        .padding(.trailing, 4)
                }

                VStack(spacing: 12) {
                    detailRow(icon: "calendar", title: "Air Date", value: episode.airDate, index: 0)
                    detailRow(icon: "film", title: "Episode Code", value: episode.episode, index: 1)
                    detailRow(icon: "person.3", title: "Characters", value: "\(episode.characters.count) character(s)", index: 2)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                appeared = true
            }
        }
    }

    private func detailRow(icon: String, title: String, value: String, index: Int) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.accentSwiftUI)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(.secondaryLabel))
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(.label))
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
        .animation(.spring(duration: 0.45, bounce: 0.2).delay(Double(index) * 0.06 + 0.15), value: appeared)
    }

    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggleEpisode(episode.id)
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                isFavorite.toggle()
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}
