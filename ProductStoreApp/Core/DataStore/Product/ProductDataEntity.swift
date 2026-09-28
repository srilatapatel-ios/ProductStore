//
//  ProductDataEntity.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import SwiftData

@Model
final class ProductDataEntity {

    @Attribute(.unique)
    var id: Int
    var title: String
    var productDescription: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String?
    var category: String
    var thumbnail: String
    var images: [String]
    var isFavorite: Bool
    var syncStatus: String
    var updatedAt: Date
    var localImageData: Data?

    init(
        id: Int,
        title: String,
        productDescription: String,
        price: Double,
        discountPercentage: Double,
        rating: Double,
        stock: Int,
        brand: String?,
        category: String,
        thumbnail: String,
        images: [String],
        isFavorite: Bool = false,
        syncStatus: String = SyncStatus.synced.rawValue,
        updatedAt: Date = Date(),
        localImageData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.productDescription = productDescription
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
        self.isFavorite = isFavorite
        self.syncStatus = syncStatus
        self.updatedAt = updatedAt
        self.localImageData = localImageData
    }
}
extension ProductDataEntity {

    convenience init(apiEntity: ProductAPIEntity) {
        self.init(
            id: apiEntity.id,
            title: apiEntity.title,
            productDescription: apiEntity.description,
            price: apiEntity.price,
            discountPercentage: apiEntity.discountPercentage,
            rating: apiEntity.rating,
            stock: apiEntity.stock,
            brand: apiEntity.brand,
            category: apiEntity.category,
            thumbnail: apiEntity.thumbnail,
            images: apiEntity.images,
            isFavorite: false,
            syncStatus: SyncStatus.synced.rawValue,
            updatedAt: Date()
        )
    }
}

extension ProductDataEntity {

    func toViewEntity() -> ProductViewEntity {
        ProductViewEntity(
            id: id,
            title: title,
            priceText: String(format: "$%.2f", price),
            description: productDescription,
            imageURL: thumbnail,
            images: images,
            ratingText: String(format: "⭐ %.1f", rating),
            stockText: stock > 0 ? "\(stock) in stock" : "Out of stock",
            category: category,
            isFavorite: isFavorite,
            syncStatus: SyncStatus(rawValue: syncStatus) ?? .failed,
            localImageData: localImageData
        )
    }
}
