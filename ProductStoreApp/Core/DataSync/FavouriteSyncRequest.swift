//
//  FavouriteSyncRequest.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

struct FavoriteSyncRequest: Encodable {
    let productID: Int
    let isFavorite: Bool
}
