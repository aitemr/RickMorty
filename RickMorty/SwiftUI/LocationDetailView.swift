//
//  LocationDetailView.swift
//  RickMorty
//

import SwiftUI

struct LocationDetailView: View {
    let location: RMLocation
    @State private var isFavorite: Bool

    init(location: RMLocation) {
        self.location = location
        _isFavorite = State(initialValue: FavoritesManager.shared.isLocationFavorite(location.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Theme.accentSwiftUI.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Theme.accentSwiftUI)
                }
                .padding(.top, 20)

                HStack {
                    Spacer()
                    Text(location.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    favoriteButton
                        .padding(.trailing, 4)
                }

                VStack(spacing: 12) {
                    InfoRowView(title: "Type", value: location.type)
                    InfoRowView(title: "Dimension", value: location.dimension)
                    InfoRowView(title: "Residents", value: "\(location.residents.count) resident(s)")
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var favoriteButton: some View {
        Button {
            FavoritesManager.shared.toggleLocation(location.id)
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.red)
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}
