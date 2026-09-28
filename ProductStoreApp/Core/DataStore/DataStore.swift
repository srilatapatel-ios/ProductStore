//
//  DataStore.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import SwiftData

protocol DataStoring {
    
    func fetchProducts() throws -> [ProductDataEntity]
    
    func fetchFavorites() throws -> [ProductDataEntity]
    
    func saveProducts(_ products: [ProductAPIEntity]) throws
    
    func updateFavorite(productID: Int, isFavorite: Bool) throws
    
    func fetchPendingFavoriteChanges() throws -> [FavoriteSyncDataEntity]
    
    func deleteFavoriteSyncData(_ syncData: FavoriteSyncDataEntity) throws
    
    func markFavoriteSyncAsCompleted(_ syncData: FavoriteSyncDataEntity) throws
    
    func saveChanges() throws
    
    func addProduct(title: String, description: String, price: Double, category: String, imageData: Data?) throws
}

final class DataStore: DataStoring {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Products
    
    func fetchProducts() throws -> [ProductDataEntity] {
        let descriptor = FetchDescriptor<ProductDataEntity>(
            sortBy: [
                SortDescriptor(\.id)
            ]
        )
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Favorites
    
    func fetchFavorites() throws -> [ProductDataEntity] {
        let predicate = #Predicate<ProductDataEntity> { $0.isFavorite == true }
        let descriptor = FetchDescriptor<ProductDataEntity>(predicate: predicate, sortBy: [SortDescriptor(\.id)])
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Save Products
    
    func saveProducts(_ products: [ProductAPIEntity]) throws {
        for product in products {
            let predicate = #Predicate<ProductDataEntity> { $0.id == product.id }
            let descriptor = FetchDescriptor<ProductDataEntity>(predicate: predicate)
            if let existingProduct = try modelContext.fetch(descriptor).first {
                // Update server-controlled properties only.
                existingProduct.title = product.title
                existingProduct.productDescription = product.description
                existingProduct.price = product.price
                existingProduct.discountPercentage =
                product.discountPercentage
                existingProduct.rating = product.rating
                existingProduct.stock = product.stock
                existingProduct.brand = product.brand
                existingProduct.category = product.category
                existingProduct.thumbnail = product.thumbnail
                existingProduct.images = product.images
                existingProduct.updatedAt = Date()
            } else {
                let dataEntity = ProductDataEntity(apiEntity: product)
                modelContext.insert(dataEntity)
            }
        }
        try modelContext.save()
    }
    
    // MARK: - Favorite
    
    func updateFavorite(productID: Int, isFavorite: Bool) throws {
        let predicate = #Predicate<ProductDataEntity> { $0.id == productID }
        let descriptor = FetchDescriptor<ProductDataEntity>(predicate: predicate)
        guard let product = try modelContext.fetch(descriptor).first
        else { return }
        product.isFavorite = isFavorite
        product.syncStatus = SyncStatus.pending.rawValue
        product.updatedAt = Date()
        let syncData = FavoriteSyncDataEntity(productID: productID, isFavorite: isFavorite)
        modelContext.insert(syncData)
        try modelContext.save()
    }
    
    // MARK: - Pending Sync
    
    func fetchPendingFavoriteChanges() throws -> [FavoriteSyncDataEntity] {
        let pendingStatus = SyncStatus.pending.rawValue
        let failedStatus = SyncStatus.failed.rawValue
        let predicate = #Predicate<FavoriteSyncDataEntity> {
            $0.status == pendingStatus ||
            $0.status == failedStatus
        }
        let descriptor = FetchDescriptor<FavoriteSyncDataEntity>(predicate: predicate)
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Delete Sync Data
    
    func deleteFavoriteSyncData(_ syncData: FavoriteSyncDataEntity) throws {
        modelContext.delete(syncData)
        try modelContext.save()
    }
    
    func markFavoriteSyncAsCompleted(_ syncData: FavoriteSyncDataEntity) throws {
        let productID = syncData.productID
        let predicate = #Predicate<ProductDataEntity> { $0.id == productID }
        let descriptor = FetchDescriptor<ProductDataEntity>(predicate: predicate)
        if let product = try modelContext.fetch(descriptor).first {
            product.syncStatus = SyncStatus.synced.rawValue
            product.updatedAt = Date()
        }
        modelContext.delete(syncData)
        try modelContext.save()
    }
    
    func saveChanges() throws {
        try modelContext.save()
    }
    
    func addProduct(title: String, description: String, price: Double, category: String, imageData: Data?) throws {
        let product = ProductDataEntity(
            id: Int(Date().timeIntervalSince1970),
            title: title,
            productDescription: description,
            price: price,
            discountPercentage: 0,
            rating: 0,
            stock: 1,
            brand: "ProductStore",
            category: category,
            thumbnail: "",
            images: [],
            isFavorite: false,
            syncStatus: SyncStatus.synced.rawValue,
            localImageData: imageData
        )
        modelContext.insert(product)
        try saveChanges()
    }

}
