//
//  Episode.swift
//  RickMorty
//

import Foundation

nonisolated struct EpisodeResponse: Decodable, Sendable {
    let info: APIInfo
    let results: [RMEpisode]
}

nonisolated struct RMEpisode: Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }

    static func == (lhs: RMEpisode, rhs: RMEpisode) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
