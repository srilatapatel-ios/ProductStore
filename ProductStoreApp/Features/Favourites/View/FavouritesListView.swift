//
//  FavouritesListView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct FavouritesListView: View {
    
    let repository: ProductRepository
    let dataSyncService: DataSyncService
    let imageLoader: ImageLoader
    @State private var viewModel: FavouriteListViewModel
    init(repository: ProductRepository, dataSyncService: DataSyncService, imageLoader: ImageLoader) {
        self.repository = repository
        self.dataSyncService = dataSyncService
        _viewModel = State(initialValue: FavouriteListViewModel(repository: repository,
                                                                dataSyncService: dataSyncService)
        )
        self.imageLoader = imageLoader
    }
    
    var body: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Something went wrong")
                    Text(errorMessage)
                        .foregroundStyle(.secondary)
                }
            } else if viewModel.favorites.isEmpty {
                ContentUnavailableView(
                    "No Favorites",
                    systemImage: "heart",
                    description: Text(
                        "Products you favorite will appear here."
                    )
                )
            } else {
                List(viewModel.favorites) { product in
                    NavigationLink {
                        ProductDetailView(product: product, repository: repository, imageLoader: imageLoader)
                    } label: {
                        FavouriteRowView(product: product, onRemove: {
                            viewModel.removeFavorite(productID: product.id)
                        }, imageLoader: imageLoader
                        )
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .task {
            viewModel.loadFavorites()
        }
        .refreshable {
            await viewModel.refreshFavorites()
        }
    }
}
