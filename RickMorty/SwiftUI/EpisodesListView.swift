//
//  EpisodesListView.swift
//  RickMorty
//

import SwiftUI

struct EpisodesListView: View {
    @State private var viewModel = EpisodesViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.episodes.isEmpty {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if viewModel.hasError && viewModel.episodes.isEmpty {
                    emptyStateView
                } else {
                    scrollContent
                }
            }
            .navigationTitle("Episodes")
            .task {
                if viewModel.episodes.isEmpty {
                    await viewModel.loadEpisodes()
                }
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.episodes, id: \.id) { episode in
                    NavigationLink(value: episode) {
                        EpisodeCardView(episode: episode)
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
