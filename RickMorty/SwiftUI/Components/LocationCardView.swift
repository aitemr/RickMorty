//
//  LocationCardView.swift
//  RickMorty
//

import SwiftUI

struct LocationCardView: View {
    let location: RMLocation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "globe.americas.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.accentSwiftUI)
                Spacer()
                Text("\(location.residents.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.accentSwiftUI)
                    .clipShape(Capsule())
            }

            Text(location.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(.label))
                .lineLimit(2)

            Text(location.type)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(location.name), \(location.type)")
    }
}
