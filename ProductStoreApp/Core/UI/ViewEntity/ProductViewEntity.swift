//
//  ProductViewEntity.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

struct ProductViewEntity: Identifiable {

    let id: Int
    let title: String
    let priceText: String
    let description: String
    let imageURL: String
    let images: [String]
    let ratingText: String
    let stockText: String
    let category: String
    let isFavorite: Bool
    let syncStatus: SyncStatus
    let localImageData: Data?
}
