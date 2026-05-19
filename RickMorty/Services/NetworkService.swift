//
//  NetworkService.swift
//  RickMorty
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()

    private let baseURL = "https://rickandmortyapi.com/api"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func fetchCharacters(page: Int = 1) async throws -> APIResponse {
        try await fetch(endpoint: "character", page: page)
    }

    func fetchLocations(page: Int = 1) async throws -> LocationResponse {
        try await fetch(endpoint: "location", page: page)
    }

    func fetchEpisodes(page: Int = 1) async throws -> EpisodeResponse {
        try await fetch(endpoint: "episode", page: page)
    }

    private func fetch<T: Decodable>(endpoint: String, page: Int) async throws -> T {
        guard var components = URLComponents(string: "\(baseURL)/\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        components.queryItems = [URLQueryItem(name: "page", value: "\(page)")]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .serverError: return "Server error"
        case .decodingError: return "Failed to decode response"
        }
    }
}
