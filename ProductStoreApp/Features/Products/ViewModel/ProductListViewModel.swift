//
//  ProductListViewModel.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

@MainActor
@Observable
final class ProductListViewModel {

    private let repository: ProductRepositorying

    var products: [ProductViewEntity] = []
    var isLoading = false
    var errorMessage: String?

    init(repository: ProductRepositorying) {
        self.repository = repository
    }

    func loadProducts() async {
        errorMessage = nil
        do {
            let localProducts = try await repository.fetchProducts()
            if !localProducts.isEmpty {
                products = localProducts
                return
            }
            isLoading = true
            try await repository.refreshProducts()
            products = try await repository.fetchProducts()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleFavorite(productID: Int, isFavorite: Bool) {
        do {
            try repository.updateFavorite(
                productID: productID,
                isFavorite: isFavorite
            )
            if let index = products.firstIndex(
                where: { $0.id == productID }
            ) {
                let product = products[index]
                products[index] = ProductViewEntity(
                    id: product.id,
                    title: product.title,
                    priceText: product.priceText,
                    description: product.description,
                    imageURL: product.imageURL,
                    images: product.images,
                    ratingText: product.ratingText,
                    stockText: product.stockText,
                    category: product.category,
                    isFavorite: isFavorite,
                    syncStatus: .pending, localImageData: product.localImageData
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func reloadProducts() async {
        do {
            products = try await repository.fetchProducts()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
