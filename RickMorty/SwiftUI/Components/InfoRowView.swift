//
//  InfoRowView.swift
//  RickMorty
//

import SwiftUI

struct InfoRowView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.label))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
