//
//  LocationsListView.swift
//  RickMorty
//

import SwiftUI

struct LocationsListView: View {
    @State private var viewModel = LocationsViewModel()
    @State private var selectedFilter = 0
    @Namespace private var heroNamespace

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var filteredLocations: [RMLocation] {
        switch selectedFilter {
        case 1: return viewModel.locations.filter { $0.type == "Planet" }
        case 2: return viewModel.locations.filter { $0.type != "Planet" }
        default: return viewModel.locations
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
                    } else {
                        scrollContent
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
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
            Text("Locations")
                .font(.system(size: 24, weight: .black))
                .foregroundStyle(Color(.label))

            Picker("Filter", selection: $selectedFilter) {
                Text("ALL").tag(0)
                Text("PLANETS").tag(1)
                Text("OTHER").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color(.systemGroupedBackground))
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
        .navigationDestination(for: RMLocation.self) { location in
            LocationDetailView(location: location)
                .navigationTransition(.zoom(sourceID: location.id, in: heroNamespace))
        }
    }

    // MARK: - Empty State

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
