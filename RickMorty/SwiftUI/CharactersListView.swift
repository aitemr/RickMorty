//
//  CharactersListView.swift
//  RickMorty
//

import SwiftUI

struct CharactersListView: View {
    @State private var viewModel = CharactersViewModel()
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.characters.isEmpty {
                    ProgressView()
                        .scaleEffect(1.2)
                } else if viewModel.hasError && viewModel.characters.isEmpty {
                    emptyStateView
                } else {
                    scrollContent
                }
            }
            .navigationTitle("Characters")
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.loadCharacters()
                }
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.characters, id: \.id) { character in
                    NavigationLink(value: character) {
                        CharacterCardView(character: character)
                    }
                    .buttonStyle(.plain)
                    .task {
                        await viewModel.loadMoreIfNeeded(currentItem: character)
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
        .navigationDestination(for: RMCharacter.self) { character in
            CharacterDetailView(character: character)
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
