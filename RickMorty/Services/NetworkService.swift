//
//  NetworkService.swift
//  RickMorty
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://rickandmortyapi.com/api/character"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func fetchCharacters(page: Int = 1) async throws -> APIResponse {
        guard var components = URLComponents(string: baseURL) else {
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

        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
        return decoded
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
