//
//  EpisodeCardView.swift
//  RickMorty
//

import SwiftUI

struct EpisodeCardView: View {
    let episode: RMEpisode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(episode.episode)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Theme.accentSwiftUI)
                    .clipShape(Capsule())
                Spacer()
            }

            Text(episode.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(.label))
                .lineLimit(2)

            Text(episode.airDate)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(episode.name), \(episode.episode)")
    }
}
