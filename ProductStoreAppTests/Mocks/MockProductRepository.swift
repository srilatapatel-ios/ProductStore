//
//  MockProductRepository.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import Foundation
@testable import ProductStoreApp

final class MockProductRepository: ProductRepositorying {

    var products: [ProductViewEntity] = []
    var fetchProductsCallCount = 0
    var updateFavoriteCallCount = 0
    var updatedProductID: Int?
    var updatedFavoriteValue: Bool?

    func fetchProducts() async throws -> [ProductViewEntity] {
        fetchProductsCallCount += 1
        return products
    }

    func refreshProducts() async throws {
        // Nothing needed for this test
    }

    func updateFavorite(productID: Int, isFavorite: Bool) throws {
        updateFavoriteCallCount += 1
        updatedProductID = productID
        updatedFavoriteValue = isFavorite
    }
    
    func fetchFavorites() throws -> [ProductViewEntity] {
        return []
    }
    
    func addProduct(title: String, description: String, price: Double, category: String, selectedImage: Data?) throws {
        
    }
}
