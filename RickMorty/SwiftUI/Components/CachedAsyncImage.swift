//
//  CachedAsyncImage.swift
//  RickMorty
//

import SwiftUI

struct CachedAsyncImage: View {
    let urlString: String
    @State private var image: UIImage?
    @State private var isLoading = true

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ZStack {
                    Color(.systemGray5)
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            } else {
                ZStack {
                    Color(.systemGray5)
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundStyle(.gray.opacity(0.5))
                }
            }
        }
        .task(id: urlString) {
            isLoading = true
            image = await ImageLoader.shared.loadImage(from: urlString)
            isLoading = false
        }
    }
}
