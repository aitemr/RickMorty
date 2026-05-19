//
//  CharactersViewModel.swift
//  RickMorty
//

import Foundation

@Observable
final class CharactersViewModel {
    var characters: [RMCharacter] = []
    var isLoading = false
    var hasError = false
    var isPaginating = false

    private var currentPage = 1
    private var totalPages = 1

    func loadCharacters() async {
        guard !isLoading, !isPaginating, currentPage <= totalPages else { return }

        let isFirstPage = currentPage == 1
        if isFirstPage {
            isLoading = true
            hasError = false
        } else {
            isPaginating = true
        }

        do {
            let response = try await NetworkService.shared.fetchCharacters(page: currentPage)
            totalPages = response.info.pages
            characters.append(contentsOf: response.results)
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
        characters.removeAll()
        await loadCharacters()
    }

    func loadMoreIfNeeded(currentItem: RMCharacter) async {
        guard let lastItem = characters.last, lastItem.id == currentItem.id else { return }
        await loadCharacters()
    }
}
