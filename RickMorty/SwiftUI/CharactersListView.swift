//
//  CharactersListView.swift
//  RickMorty
//

import SwiftUI

struct CharactersListView: View {
    @State private var viewModel = CharactersViewModel()
    @State private var selectedFilter = 0
    @State private var searchText = ""
    @Namespace private var heroNamespace
    private var loc = LocalizationManager.shared

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var filteredCharacters: [RMCharacter] {
        var result: [RMCharacter]
        switch selectedFilter {
        case 1: result = viewModel.characters.filter { $0.status == .alive }
        case 2: result = viewModel.characters.filter { $0.status == .dead }
        default: result = viewModel.characters
        }
        guard !searchText.isEmpty else { return result }
        return result.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.species.localizedCaseInsensitiveContains(searchText) ||
            $0.location.name.localizedCaseInsensitiveContains(searchText)
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
                    } else if !searchText.isEmpty && filteredCharacters.isEmpty {
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
                if viewModel.characters.isEmpty {
                    await viewModel.loadCharacters()
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: 12) {
            (Text(loc.string("characters.title.the"))
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(.label))
            + Text(loc.string("characters.title.name"))
                .font(.system(size: 24, weight: .heavy).italic())
                .foregroundColor(Theme.accentSwiftUI)
            )

            Text(loc.string("characters.subtitle"))
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.secondary)
                .tracking(3)

            Picker("Filter", selection: $selectedFilter) {
                Text(loc.string("characters.filter.all")).tag(0)
                Text(loc.string("characters.filter.alive")).tag(1)
                Text(loc.string("characters.filter.dead")).tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)

            searchBar(prompt: loc.string("characters.search"))
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
        .scrollDismissesKeyboard(.immediately)
        .navigationDestination(for: RMCharacter.self) { character in
            CharacterDetailView(character: character, heroNamespace: heroNamespace)
                .navigationTransition(.zoom(sourceID: character.id, in: heroNamespace))
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
