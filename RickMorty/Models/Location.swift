//
//  Location.swift
//  RickMorty
//

import Foundation

nonisolated struct LocationResponse: Decodable, Sendable {
    let info: APIInfo
    let results: [RMLocation]
}

nonisolated struct RMLocation: Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String

    static func == (lhs: RMLocation, rhs: RMLocation) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
