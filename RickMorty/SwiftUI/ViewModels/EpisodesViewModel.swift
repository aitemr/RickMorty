//
//  EpisodesViewModel.swift
//  RickMorty
//

import Foundation

@Observable
final class EpisodesViewModel {
    var episodes: [RMEpisode] = []
    var isLoading = false
    var hasError = false
    var isPaginating = false

    private var currentPage = 1
    private var totalPages = 1

    func loadEpisodes() async {
        guard !isLoading, !isPaginating, currentPage <= totalPages else { return }

        let isFirstPage = currentPage == 1
        if isFirstPage {
            isLoading = true
            hasError = false
        } else {
            isPaginating = true
        }

        do {
            let response = try await NetworkService.shared.fetchEpisodes(page: currentPage)
            totalPages = response.info.pages
            episodes.append(contentsOf: response.results)
            currentPage += 1
        } catch {
            if isFirstPage { hasError = true }
        }

        isLoading = false
        isPaginating = false
    }

    func retry() async {
        currentPage = 1
        totalPages = 1
        episodes.removeAll()
        await loadEpisodes()
    }

    func loadMoreIfNeeded(currentItem: RMEpisode) async {
        guard let lastItem = episodes.last, lastItem.id == currentItem.id else { return }
        await loadEpisodes()
    }
}
