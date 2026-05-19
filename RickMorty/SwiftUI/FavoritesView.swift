//
//  FavoritesView.swift
//  RickMorty
//

import SwiftUI

struct FavoritesView: View {
    @State private var viewModel = FavoritesViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if viewModel.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundStyle(.gray)
                        Text("No favorites yet")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("Tap the heart icon on any item to add it here")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    scrollContent
                }
            }
            .navigationTitle("Favorites")
            .task {
                await viewModel.loadAndRefresh()
            }
            .onReceive(NotificationCenter.default.publisher(for: FavoritesManager.didChangeNotification)) { _ in
                viewModel.refreshFavorites()
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if !viewModel.favoriteCharacters.isEmpty {
                    sectionHeader("Characters")
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.favoriteCharacters, id: \.id) { character in
                            NavigationLink(value: character) {
                                CharacterCardView(character: character)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if !viewModel.favoriteLocations.isEmpty {
                    sectionHeader("Locations")
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.favoriteLocations, id: \.id) { location in
                            NavigationLink(value: location) {
                                LocationCardView(location: location)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if !viewModel.favoriteEpisodes.isEmpty {
                    sectionHeader("Episodes")
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.favoriteEpisodes, id: \.id) { episode in
                            NavigationLink(value: episode) {
                                EpisodeCardView(episode: episode)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .navigationDestination(for: RMCharacter.self) { character in
            CharacterDetailView(character: character)
        }
        .navigationDestination(for: RMLocation.self) { location in
            LocationDetailView(location: location)
        }
        .navigationDestination(for: RMEpisode.self) { episode in
            EpisodeDetailView(episode: episode)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color(.label))
            .padding(.top, 8)
    }
}
