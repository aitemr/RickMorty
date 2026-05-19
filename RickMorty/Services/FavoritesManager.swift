//
//  FavoritesManager.swift
//  RickMorty
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()

    private let defaults = UserDefaults.standard
    private let characterKey = "favoriteCharacterIDs"
    private let locationKey = "favoriteLocationIDs"
    private let episodeKey = "favoriteEpisodeIDs"

    static let didChangeNotification = Notification.Name("FavoritesDidChange")

    private init() {}

    // MARK: - Characters

    func isCharacterFavorite(_ id: Int) -> Bool {
        characterIDs.contains(id)
    }

    func toggleCharacter(_ id: Int) {
        var ids = characterIDs
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        characterIDs = ids
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    private var characterIDs: Set<Int> {
        get { Set(defaults.array(forKey: characterKey) as? [Int] ?? []) }
        set { defaults.set(Array(newValue), forKey: characterKey) }
    }

    // MARK: - Locations

    func isLocationFavorite(_ id: Int) -> Bool {
        locationIDs.contains(id)
    }

    func toggleLocation(_ id: Int) {
        var ids = locationIDs
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        locationIDs = ids
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    private var locationIDs: Set<Int> {
        get { Set(defaults.array(forKey: locationKey) as? [Int] ?? []) }
        set { defaults.set(Array(newValue), forKey: locationKey) }
    }

    // MARK: - Episodes

    func isEpisodeFavorite(_ id: Int) -> Bool {
        episodeIDs.contains(id)
    }

    func toggleEpisode(_ id: Int) {
        var ids = episodeIDs
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        episodeIDs = ids
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }

    private var episodeIDs: Set<Int> {
        get { Set(defaults.array(forKey: episodeKey) as? [Int] ?? []) }
        set { defaults.set(Array(newValue), forKey: episodeKey) }
    }

    // MARK: - All Favorite IDs

    var allFavoriteCharacterIDs: [Int] { Array(characterIDs) }
    var allFavoriteLocationIDs: [Int] { Array(locationIDs) }
    var allFavoriteEpisodeIDs: [Int] { Array(episodeIDs) }
}
