//
//  ProductRepository.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

final class ProductRepository: ProductRepositorying {

    private let dataStore: DataStore
    private let networkService: NetworkRequestManaging

    init(
        dataStore: DataStore,
        networkService: NetworkRequestManaging
    ) {
        self.dataStore = dataStore
        self.networkService = networkService
    }

    func fetchProducts() async throws -> [ProductViewEntity] {
        let products = try dataStore.fetchProducts()
        return products.map {
            $0.toViewEntity()
        }
    }

    func refreshProducts() async throws {
        let response: ProductAPIResponse = try await networkService.get(
            url: Endpoint.products.url,
            parameters: [
                "limit": "0"
            ]
        )
        var products = response.products
        if products.count < 200 {
            products.append(
                contentsOf: LocalProductSeed.products.prefix(
                    200 - products.count
                )
            )
        }
        try dataStore.saveProducts(products)
    }
    
    func fetchFavorites() throws -> [ProductViewEntity] {
        let favorites = try dataStore.fetchFavorites()
        return favorites.map {
            $0.toViewEntity()
        }
    }

    func updateFavorite(productID: Int, isFavorite: Bool) throws {
        try dataStore.updateFavorite(
            productID: productID,
            isFavorite: isFavorite
        )
    }
    
    func addProduct(title: String, description: String, price: Double, category: String, selectedImage: Data?) throws {
        try dataStore.addProduct(
            title: title,
            description: description,
            price: price,
            category: category,
            imageData: selectedImage,
        )
    }
    
}

protocol ProductRepositorying {

    func fetchProducts() async throws -> [ProductViewEntity]

    func refreshProducts() async throws

    func fetchFavorites() throws -> [ProductViewEntity]

    func updateFavorite(productID: Int, isFavorite: Bool) throws
    
    func addProduct(title: String, description: String, price: Double, category: String, selectedImage: Data?) throws
}

enum LocalProductSeed {

    static let products: [ProductAPIEntity] = [

        ProductAPIEntity(
            id: 1001,
            title: "Classic Cotton Shirt",
            description: "Comfortable everyday cotton shirt.",
            price: 29.99,
            discountPercentage: 10,
            rating: 4.2,
            stock: 25,
            brand: "ProductStore",
            category: "mens-shirts",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        ),

        ProductAPIEntity(
            id: 1002,
            title: "Everyday Sneakers",
            description: "Lightweight sneakers for daily use.",
            price: 59.99,
            discountPercentage: 15,
            rating: 4.4,
            stock: 30,
            brand: "ProductStore",
            category: "mens-shoes",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        ),

        ProductAPIEntity(
            id: 1003,
            title: "Travel Backpack",
            description: "Spacious backpack suitable for travel.",
            price: 44.99,
            discountPercentage: 8,
            rating: 4.1,
            stock: 18,
            brand: "ProductStore",
            category: "bags",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        ),

        ProductAPIEntity(
            id: 1004,
            title: "Wireless Headphones",
            description: "Wireless headphones with comfortable ear cushions.",
            price: 79.99,
            discountPercentage: 12,
            rating: 4.5,
            stock: 20,
            brand: "ProductStore",
            category: "smartphones",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        ),

        ProductAPIEntity(
            id: 1005,
            title: "Minimal Desk Lamp",
            description: "Compact LED desk lamp for workspaces.",
            price: 24.99,
            discountPercentage: 5,
            rating: 4.0,
            stock: 40,
            brand: "ProductStore",
            category: "lighting",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        ),

        ProductAPIEntity(
            id: 1006,
            title: "Ceramic Coffee Mug",
            description: "Simple ceramic mug for everyday coffee.",
            price: 12.99,
            discountPercentage: 0,
            rating: 4.3,
            stock: 50,
            brand: "ProductStore",
            category: "kitchen-accessories",
            thumbnail: "https://dummyjson.com/image/200x200",
            images: [
                "https://dummyjson.com/image/400x400"
            ]
        )
    ]
}
