//
//  ImageLoader.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import SwiftUI

final class ImageLoader {

    private let cache: ImageCache
    private let session: URLSession

    init(
        cache: ImageCache = ImageCache(),
        session: URLSession = .shared
    ) {
        self.cache = cache
        self.session = session
    }

    func load(from url: URL) async throws -> UIImage {
        if let cachedImage = cache.image(for: url) {
            return cachedImage
        }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageLoaderError.invalidImage
        }
        guard (200...299).contains(httpResponse.statusCode), let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidImage
        }
        cache.insert(image, for: url)
        return image
    }
}

enum ImageLoaderError: Error {
    case invalidImage
}
