//
//  MockDataStore.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 27/09/26.
//

@testable import ProductStoreApp
import Foundation

final class MockDataStore: DataStoring {

    var pendingChanges: [FavoriteSyncDataEntity] = []

    var completedChanges: [FavoriteSyncDataEntity] = []

    var saveChangesCallCount = 0

    func fetchPendingFavoriteChanges() throws -> [FavoriteSyncDataEntity] {
        return pendingChanges
    }

    func markFavoriteSyncAsCompleted(_ change: FavoriteSyncDataEntity) throws {
        completedChanges.append(change)
    }

    func saveChanges() throws {
        saveChangesCallCount += 1
    }
    
    func deleteFavoriteSyncData(_ syncData: FavoriteSyncDataEntity) throws {
        
    }
    
    func addProduct(title: String, description: String, price: Double, category: String, imageData: Data?) throws {
        
    }
    
    func fetchProducts() throws -> [ProductDataEntity] {
        return []
    }
    
    func fetchFavorites() throws -> [ProductDataEntity] {
        return []
    }
    
    func saveProducts(_ products: [ProductAPIEntity]) throws {
        
    }
    
    func updateFavorite(productID: Int, isFavorite: Bool) throws {
        
    }
}
