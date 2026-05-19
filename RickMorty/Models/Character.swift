//
//  Character.swift
//  RickMorty
//

import Foundation

nonisolated struct APIResponse: Decodable, Sendable {
    let info: APIInfo
    let results: [RMCharacter]
}

nonisolated struct APIInfo: Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

nonisolated struct RMCharacter: Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String

    static func == (lhs: RMCharacter, rhs: RMCharacter) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated enum Status: String, Decodable, Sendable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }

    nonisolated struct Location: Decodable, Hashable, Sendable {
        let name: String
        let url: String
    }
}
