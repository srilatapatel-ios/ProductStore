//
//  ProductImageView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import SwiftUI

struct ProductImageView: View {

    let localImageData: Data?
    let imageURL: String
    let imageLoader: ImageLoader

    var body: some View {

        if let localImageData,
           let uiImage = UIImage(data: localImageData) {

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()

        } else {

            CachedImage(
                url: URL(string: imageURL),
                imageLoader: imageLoader
            )
        }
    }
}
