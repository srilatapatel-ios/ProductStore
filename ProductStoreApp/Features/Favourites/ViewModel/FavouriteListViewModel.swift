//
//  FavouriteListViewModel.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

@MainActor
@Observable
final class FavouriteListViewModel {
    
    private let repository: ProductRepository
    private let dataSyncService: DataSyncService
    
    var favorites: [ProductViewEntity] = []
    var isRefreshing = false
    var errorMessage: String?
    
    init(
        repository: ProductRepository,
        dataSyncService: DataSyncService
    ) {
        self.repository = repository
        self.dataSyncService = dataSyncService
    }
    
    func loadFavorites() {
        do {
            favorites = try repository.fetchFavorites()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refreshFavorites() async {
        isRefreshing = true
        errorMessage = nil
        await dataSyncService.syncPendingFavoriteChanges()
        loadFavorites()
        isRefreshing = false
    }
    
    func removeFavorite(productID: Int) {
        do {
            try repository.updateFavorite(productID: productID, isFavorite: false)
            loadFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
