//
//  ProductAPIEntity.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

struct ProductAPIEntity: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let category: String
    let thumbnail: String
    let images: [String]
}
