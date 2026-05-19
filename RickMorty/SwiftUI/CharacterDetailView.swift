//
//  CharacterDetailView.swift
//  RickMorty
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    var heroNamespace: Namespace.ID?
    @State private var isFavorite: Bool
    @State private var appeared = false

    init(character: RMCharacter, heroNamespace: Namespace.ID? = nil) {
        self.character = character
        self.heroNamespace = heroNamespace
        _isFavorite = State(initialValue: FavoritesManager.shared.isCharacterFavorite(character.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero image with parallax-like sticky behavior
                GeometryReader { geo in
                    let minY = geo.frame(in: .scrollView).minY
                    let height: CGFloat = 340
                    let offset = minY > 0 ? -minY : 0
                    let stretchHeight = minY > 0 ? height + minY : height

                    ZStack(alignment: .topLeading) {
                        CachedAsyncImage(urlString: character.image)
                            .frame(width: geo.size.width, height: stretchHeight)
                            .clipped()
                            .offset(y: offset)

                        // Gradient overlay for text readability
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.3)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(width: geo.size.width, height: stretchHeight)
                        .offset(y: offset)

                        HStack {
                            statusBadge
                            Spacer()
                            favoriteButton
                        }
                        .padding(16)
                    }
                }
                .frame(height: 340)

                // Info section
                VStack(alignment: .leading, spacing: 16) {
                    Text(character.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 15)

                    infoRows
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                appeared = true
            }
        }
    }

    private var infoRows: some View {
        let rows: [(String, String, String)] = [
            ("dna", "Species", character.species),
            ("figure.stand", "Gender", character.gender),
            ("globe", "Origin", character.origin.name),
            ("mappin.and.ellipse", "Location", character.location.name),
            ("play.tv", "Episodes", "\(character.episode.count) episode(s)"),
        ]

        return VStack(spacing: 12) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                HStack(spacing: 14) {
                    Image(systemName: row.0)
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.accentSwiftUI)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.1)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color(.secondaryLabel))
                        Text(row.2)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(.label))
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 15)
                .animation(.spring(duration: 0.45, bounce: 0.2).delay(Double(index) * 0.06 + 0.1), value: appeared)
            }
        }
    }

    private var statusBadge: some View {
        Text(character.status.rawValue.uppercased())
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor)
            .clipShape(Capsule())
    }

    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggleCharacter(character.id)
            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                isFavorite.toggle()
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.red)
                .scaleEffect(isFavorite ? 1.0 : 0.9)
                .contentTransition(.symbolEffect(.replace))
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
