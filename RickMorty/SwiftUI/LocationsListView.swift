//
//  LocationsListView.swift
//  RickMorty
//

import SwiftUI

struct LocationsListView: View {
    @State private var viewModel = LocationsViewModel()
    @State private var searchText = ""
    @Namespace private var heroNamespace
    private var loc = LocalizationManager.shared

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var filteredLocations: [RMLocation] {
        guard !searchText.isEmpty else { return viewModel.locations }
        return viewModel.locations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText) ||
            $0.dimension.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                Group {
                    if viewModel.isLoading && viewModel.locations.isEmpty {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else if viewModel.hasError && viewModel.locations.isEmpty {
                        Spacer()
                        emptyStateView
                        Spacer()
                    } else if !searchText.isEmpty && filteredLocations.isEmpty {
                        Spacer()
                        noSearchResultsView
                        Spacer()
                    } else {
                        scrollContent
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationBarHidden(true)
            .task {
                if viewModel.locations.isEmpty {
                    await viewModel.loadLocations()
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 12) {
            Text(loc.string("locations.title"))
                .font(.system(size: 24, weight: .black))
                .foregroundStyle(Color(.label))

            searchBar(prompt: loc.string("locations.search"))
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color(.systemGroupedBackground))
    }

    private func searchBar(prompt: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(prompt, text: $searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
    }

    // MARK: - Content

    private var scrollContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(filteredLocations, id: \.id) { location in
                    NavigationLink(value: location) {
                        LocationCardView(location: location)
                            .matchedTransitionSource(id: location.id, in: heroNamespace)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await viewModel.loadMoreIfNeeded(currentItem: location)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if viewModel.isPaginating {
                ProgressView()
                    .padding(.vertical, 16)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationDestination(for: RMLocation.self) { location in
            LocationDetailView(location: location)
                .navigationTransition(.zoom(sourceID: location.id, in: heroNamespace))
        }
    }

    // MARK: - No Search Results

    private var noSearchResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("\(loc.string("search.noResults")) \"\(searchText)\"")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(loc.string("search.tryDifferent"))
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            Text(loc.string("empty.noData"))
                .font(.headline)
                .foregroundStyle(.secondary)
            Button(loc.string("empty.retry")) {
                Task { await viewModel.retry() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accentSwiftUI)
        }
    }
}
