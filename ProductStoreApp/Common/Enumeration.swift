//
//  Enumeration.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

enum OperationType: String, Codable {
    case updateFavorite
}

enum SyncStatus: String, Codable {
    case pending
    case syncing
    case synced
    case failed
}

enum AppTab: Hashable {
    case products
    case favorites
}
