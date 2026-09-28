//
//  CachedImage.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import SwiftUI

struct CachedImage: View {

    let url: URL?
    let imageLoader: ImageLoader

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {

        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let url else { return }
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let loadedImage = try await imageLoader.load(from: url)
            guard !Task.isCancelled else { return }
            image = loadedImage
        } catch {
            image = nil
        }
    }
}
