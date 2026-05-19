//
//  LocationsViewModel.swift
//  RickMorty
//

import Foundation

@Observable
final class LocationsViewModel {
    var locations: [RMLocation] = []
    var isLoading = false
    var hasError = false
    var isPaginating = false

    private var currentPage = 1
    private var totalPages = 1

    func loadLocations() async {
        guard !isLoading, !isPaginating, currentPage <= totalPages else { return }

        let isFirstPage = currentPage == 1
        if isFirstPage {
            isLoading = true
            hasError = false
        } else {
            isPaginating = true
        }

        do {
            let response = try await NetworkService.shared.fetchLocations(page: currentPage)
            totalPages = response.info.pages
            locations.append(contentsOf: response.results)
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
        locations.removeAll()
        await loadLocations()
    }

    func loadMoreIfNeeded(currentItem: RMLocation) async {
        guard let lastItem = locations.last, lastItem.id == currentItem.id else { return }
        await loadLocations()
    }
}
