//
//  Character.swift
//  RickMorty
//

import Foundation

struct APIResponse: Decodable {
    let info: APIInfo
    let results: [RMCharacter]
}

struct APIInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct RMCharacter: Decodable, Hashable {
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

    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }

    struct Location: Decodable, Hashable {
        let name: String
        let url: String
    }
}
