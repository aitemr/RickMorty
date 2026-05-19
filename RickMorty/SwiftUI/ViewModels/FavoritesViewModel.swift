//
//  FavoritesViewModel.swift
//  RickMorty
//

import Foundation

@Observable
final class FavoritesViewModel {
    var favoriteCharacters: [RMCharacter] = []
    var favoriteLocations: [RMLocation] = []
    var favoriteEpisodes: [RMEpisode] = []
    var isLoading = false

    private var allCharacters: [RMCharacter] = []
    private var allLocations: [RMLocation] = []
    private var allEpisodes: [RMEpisode] = []

    var isEmpty: Bool {
        favoriteCharacters.isEmpty && favoriteLocations.isEmpty && favoriteEpisodes.isEmpty
    }

    func loadAndRefresh() async {
        isLoading = true

        async let chars = NetworkService.shared.fetchCharacters(page: 1)
        async let locs = NetworkService.shared.fetchLocations(page: 1)
        async let eps = NetworkService.shared.fetchEpisodes(page: 1)

        do {
            let (c, l, e) = try await (chars, locs, eps)
            allCharacters = c.results
            allLocations = l.results
            allEpisodes = e.results
        } catch {}

        refreshFavorites()
        isLoading = false
    }

    func refreshFavorites() {
        let favCharIDs = FavoritesManager.shared.allFavoriteCharacterIDs
        let favLocIDs = FavoritesManager.shared.allFavoriteLocationIDs
        let favEpIDs = FavoritesManager.shared.allFavoriteEpisodeIDs

        favoriteCharacters = allCharacters.filter { favCharIDs.contains($0.id) }
        favoriteLocations = allLocations.filter { favLocIDs.contains($0.id) }
        favoriteEpisodes = allEpisodes.filter { favEpIDs.contains($0.id) }
    }
}
