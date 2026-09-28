//
//  ProductListView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct ProductListView: View {
    
    @State private var viewModel: ProductListViewModel
    let repository: ProductRepository
    let imageLoader: ImageLoader
    
    init(repository: ProductRepository, imageLoader: ImageLoader) {
        self.repository = repository
        _viewModel = State(
            initialValue: ProductListViewModel(
                repository: repository
            )
        )
        self.imageLoader = imageLoader
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading products...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Something went wrong")
                    Text(errorMessage)
                        .foregroundStyle(.secondary)
                }
            } else {
                List(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailView(product: product, repository: repository, imageLoader: imageLoader)
                    } label: {
                        ProductRowView(
                            product: product,
                            imageLoader: imageLoader, onFavoriteToggle: {
                                viewModel.toggleFavorite(
                                    productID: product.id,
                                    isFavorite: !product.isFavorite
                                )
                            }
                        )
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddProductView(repository: repository)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationTitle("Products")
        .task {
            await viewModel.loadProducts()
        }
    }
}
