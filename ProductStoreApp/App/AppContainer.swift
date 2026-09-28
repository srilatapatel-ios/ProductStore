//
//  AppContainer.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

@MainActor
final class AppContainer {

    let dataStoreContainer: DataStoreContainer
    let dataStore: DataStore
    let networkService: NetworkRequestManaging
    let networkMonitor: NetworkMonitor
    let productRepository: ProductRepository
    let dataSyncService: DataSyncService
    let imageLoader: ImageLoader

    init() throws {

        let dataStoreContainer = try DataStoreContainer()

        self.dataStoreContainer = dataStoreContainer

        let dataStore = DataStore(
            modelContext: dataStoreContainer.mainContext
        )
        self.dataStore = dataStore

        let networkService = NetworkService()
        self.networkService = networkService

        let networkMonitor = NetworkMonitor()
        self.networkMonitor = networkMonitor

        let productRepository = ProductRepository(
            dataStore: dataStore,
            networkService: networkService
        )
        self.productRepository = productRepository

        let dataSyncService = DataSyncService(
            dataStore: dataStore,
            networkService: networkService,
            networkMonitor: networkMonitor
        )
        self.dataSyncService = dataSyncService
        self.imageLoader = ImageLoader()
    }
}
