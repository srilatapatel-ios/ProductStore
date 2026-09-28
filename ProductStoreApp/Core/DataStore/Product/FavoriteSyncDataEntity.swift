//
//  FavoriteSyncDataEntity.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteSyncDataEntity {

    @Attribute(.unique)
    var id: UUID
    var productID: Int
    var isFavorite: Bool
    var status: String
    var retryCount: Int
    var createdAt: Date
    var lastError: String?

    init(
        id: UUID = UUID(),
        productID: Int,
        isFavorite: Bool,
        status: String = SyncStatus.pending.rawValue,
        retryCount: Int = 0,
        createdAt: Date = Date(),
        lastError: String? = nil
    ) {
        self.id = id
        self.productID = productID
        self.isFavorite = isFavorite
        self.status = status
        self.retryCount = retryCount
        self.createdAt = createdAt
        self.lastError = lastError
    }
}
