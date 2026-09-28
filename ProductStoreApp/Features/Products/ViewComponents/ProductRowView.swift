//
//  ProductRowView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct ProductRowView: View {

    let product: ProductViewEntity
    let imageLoader: ImageLoader
    let onFavoriteToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ProductImageView(
                localImageData: product.localImageData,
                imageURL: product.imageURL,
                imageLoader: imageLoader
            )
            .frame(width: 70, height: 70)
            .clipped()
            .cornerRadius(8)
            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(product.priceText)
                Text(product.ratingText)
                    .font(.caption)
                Text(product.stockText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                onFavoriteToggle()
            } label: {
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(product.isFavorite ? .red : .secondary)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}
