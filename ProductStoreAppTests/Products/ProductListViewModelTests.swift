//
//  ProductListViewModelTests.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import XCTest
@testable import ProductStoreApp

@MainActor
final class ProductListViewModelTests: XCTestCase {

    func testLoadProducts_whenLocalProductsExist_updatesProducts() async {

        // Arrange
        let mockRepository = MockProductRepository()

        let product = ProductViewEntity(
            id: 1,
            title: "Test Product",
            priceText: "$99",
            description: "Test description",
            imageURL: "",
            images: [],
            ratingText: "4.5",
            stockText: "10",
            category: "Test",
            isFavorite: false,
            syncStatus: .synced,
            localImageData: nil
        )
        mockRepository.products = [product]
        let viewModel = ProductListViewModel(
            repository: mockRepository
        )
        await viewModel.loadProducts()
        XCTAssertEqual(viewModel.products.count, 1)
        XCTAssertEqual(viewModel.products.first?.id, 1)
        XCTAssertEqual(viewModel.products.first?.title, "Test Product")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testToggleFavorite_updatesProductAndMarksPending() async {
            let mockRepository = MockProductRepository()
            let product = ProductViewEntity(
                id: 1,
                title: "Test Product",
                priceText: "$99",
                description: "Test description",
                imageURL: "",
                images: [],
                ratingText: "4.5",
                stockText: "10",
                category: "Test",
                isFavorite: false,
                syncStatus: .synced,
                localImageData: nil
            )
            mockRepository.products = [product]
            let viewModel = ProductListViewModel(repository: mockRepository)
            await viewModel.loadProducts()
            viewModel.toggleFavorite(productID: 1, isFavorite: true)
            XCTAssertEqual(mockRepository.updateFavoriteCallCount,1)
            XCTAssertEqual(mockRepository.updatedProductID, 1)
            XCTAssertEqual(mockRepository.updatedFavoriteValue, true)
            XCTAssertTrue(viewModel.products[0].isFavorite)
            XCTAssertEqual(viewModel.products[0].syncStatus, .pending)
        }
}
