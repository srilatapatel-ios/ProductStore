//
//  ProductDetailView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct ProductDetailView: View {

    let imageLoader: ImageLoader
    @State private var viewModel: ProductDetailViewModel

    init(
        product: ProductViewEntity,
        repository: ProductRepository,
        imageLoader: ImageLoader
    ) {
        _viewModel = State(initialValue: ProductDetailViewModel(product: product, repository: repository))
        self.imageLoader = imageLoader
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProductImageView(
                    localImageData: viewModel.product.localImageData,
                    imageURL: viewModel.product.imageURL,
                    imageLoader: imageLoader
                )
                .frame(height: 250)
                .clipped()
                .cornerRadius(12)
                Text(viewModel.product.title)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(viewModel.product.priceText)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(viewModel.product.ratingText)
                Text(viewModel.product.stockText)
                    .foregroundStyle(.secondary)
                Text(viewModel.product.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Divider()
                Text("Description")
                    .font(.headline)
                Text(viewModel.product.description)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
