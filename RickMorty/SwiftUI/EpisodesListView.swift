//
//  EpisodesListView.swift
//  RickMorty
//

import SwiftUI

struct EpisodesListView: View {
    @State private var viewModel = EpisodesViewModel()
    @State private var selectedFilter = 0
    @Namespace private var heroNamespace

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var filteredEpisodes: [RMEpisode] {
        switch selectedFilter {
        case 1: return viewModel.episodes.filter { $0.episode.hasPrefix("S01") }
        case 2: return viewModel.episodes.filter { $0.episode.hasPrefix("S02") }
        case 3: return viewModel.episodes.filter { !$0.episode.hasPrefix("S01") && !$0.episode.hasPrefix("S02") }
        default: return viewModel.episodes
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                Group {
                    if viewModel.isLoading && viewModel.episodes.isEmpty {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else if viewModel.hasError && viewModel.episodes.isEmpty {
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
                if viewModel.episodes.isEmpty {
                    await viewModel.loadEpisodes()
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 12) {
            Text("Episodes")
                .font(.system(size: 24, weight: .black))
                .foregroundStyle(Color(.label))

            Picker("Filter", selection: $selectedFilter) {
                Text("ALL").tag(0)
                Text("S01").tag(1)
                Text("S02").tag(2)
                Text("S03+").tag(3)
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
                ForEach(filteredEpisodes, id: \.id) { episode in
                    NavigationLink(value: episode) {
                        EpisodeCardView(episode: episode)
                            .matchedTransitionSource(id: episode.id, in: heroNamespace)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await viewModel.loadMoreIfNeeded(currentItem: episode)
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
        .navigationDestination(for: RMEpisode.self) { episode in
            EpisodeDetailView(episode: episode)
                .navigationTransition(.zoom(sourceID: episode.id, in: heroNamespace))
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
