//
//  AddProductViewModel.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

@MainActor
@Observable
final class AddProductViewModel {

    private let repository: ProductRepository
    var title = ""
    var description = ""
    var price = ""
    var category = ""

    var errorMessage: String?
    var selectedImageData: Data?

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func saveProduct() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a product title."
            return false
        }
        guard !description.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a description."
            return false
        }
        guard let priceValue = Double(price),
              priceValue >= 0 else {
            errorMessage = "Please enter a valid price."
            return false
        }
        guard !category.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a category."
            return false
        }
        do {
            try repository.addProduct(
                title: title,
                description: description,
                price: priceValue,
                category: category,
                selectedImage: selectedImageData
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
