//
//  ProductAPIResponse.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

struct ProductAPIResponse: Codable {
    let products: [ProductAPIEntity]
    let total: Int
    let skip: Int
    let limit: Int
}
