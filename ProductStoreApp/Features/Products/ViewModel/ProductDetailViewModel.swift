//
//  ProductDetailViewModel.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ProductDetailViewModel {

    let product: ProductViewEntity

    private let repository: ProductRepository

    var isFavorite: Bool

    init(
        product: ProductViewEntity,
        repository: ProductRepository
    ) {
        self.product = product
        self.repository = repository
        self.isFavorite = product.isFavorite
    }

    func toggleFavorite() {
        do {
            try repository.updateFavorite(productID: product.id, isFavorite: !isFavorite)
            isFavorite.toggle()
        } catch {
            // We'll improve error handling later.
        }
    }
}
