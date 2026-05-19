//
//  CharactersListView.swift
//  RickMorty
//

import SwiftUI

struct CharactersListView: View {
    @State private var viewModel = CharactersViewModel()
    @State private var selectedFilter = 0
    @Namespace private var heroNamespace

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var filteredCharacters: [RMCharacter] {
        switch selectedFilter {
        case 1: return viewModel.characters.filter { $0.status == .alive }
        case 2: return viewModel.characters.filter { $0.status == .dead }
        default: return viewModel.characters
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                Group {
                    if viewModel.isLoading && viewModel.characters.isEmpty {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    } else if viewModel.hasError && viewModel.characters.isEmpty {
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
                if viewModel.characters.isEmpty {
                    await viewModel.loadCharacters()
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 12) {
            (Text("The ")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(.label))
            + Text("Rick and Morty")
                .font(.system(size: 24, weight: .heavy).italic())
                .foregroundColor(Theme.accentSwiftUI)
            )

            Text("DIMENSION GUIDE")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.secondary)
                .tracking(3)

            Picker("Filter", selection: $selectedFilter) {
                Text("ALL").tag(0)
                Text("ALIVE").tag(1)
                Text("DEAD").tag(2)
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
                ForEach(filteredCharacters, id: \.id) { character in
                    NavigationLink(value: character) {
                        CharacterCardView(character: character)
                            .matchedTransitionSource(id: character.id, in: heroNamespace)
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
            CharacterDetailView(character: character, heroNamespace: heroNamespace)
                .navigationTransition(.zoom(sourceID: character.id, in: heroNamespace))
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
