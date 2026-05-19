//
//  LocationDetailView.swift
//  RickMorty
//

import SwiftUI

struct LocationDetailView: View {
    let location: RMLocation
    @State private var isFavorite: Bool
    @State private var appeared = false

    init(location: RMLocation) {
        self.location = location
        _isFavorite = State(initialValue: FavoritesManager.shared.isLocationFavorite(location.id))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Icon with scale animation
                ZStack {
                    Circle()
                        .fill(Theme.accentSwiftUI.opacity(0.1))
                        .frame(width: 100, height: 100)
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Theme.accentSwiftUI)
                }
                .scaleEffect(appeared ? 1.0 : 0.5)
                .opacity(appeared ? 1 : 0)
                .padding(.top, 30)

                Text(location.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(.label))
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    detailRow(icon: "building.2", title: "Type", value: location.type, index: 0)
                    detailRow(icon: "sparkles", title: "Dimension", value: location.dimension, index: 1)
                    detailRow(icon: "person.3", title: "Residents", value: "\(location.residents.count) resident(s)", index: 2)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    FavoritesManager.shared.toggleLocation(location.id)
                    withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                        isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red)
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                appeared = true
            }
        }
    }

    private func detailRow(icon: String, title: String, value: String, index: Int) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.accentSwiftUI)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(.secondaryLabel))
                Text(value)
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
        .animation(.spring(duration: 0.45, bounce: 0.2).delay(Double(index) * 0.06 + 0.15), value: appeared)
    }
}
