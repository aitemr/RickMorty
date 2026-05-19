//
//  LocationsListView.swift
//  RickMorty
//

import SwiftUI

struct LocationsListView: View {
    @State private var viewModel = LocationsViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.locations.isEmpty {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if viewModel.hasError && viewModel.locations.isEmpty {
                    emptyStateView
                } else {
                    scrollContent
                }
            }
            .navigationTitle("Locations")
            .task {
                if viewModel.locations.isEmpty {
                    await viewModel.loadLocations()
                }
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.locations, id: \.id) { location in
                    NavigationLink(value: location) {
                        LocationCardView(location: location)
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
        .navigationDestination(for: RMLocation.self) { location in
            LocationDetailView(location: location)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            Text("No data available")
                .font(.headline)
                .foregroundStyle(.secondary)
            Button("Retry") {
                Task { await viewModel.retry() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accentSwiftUI)
        }
    }
}
