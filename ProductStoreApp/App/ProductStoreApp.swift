//
//  ProductStoreApp.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

@main
struct ProductStoreApp: App {

    private let appContainer: AppContainer

    init() {
        do {
            appContainer = try AppContainer()
            appContainer.networkMonitor.startMonitoring()
        } catch {
            fatalError(
                "Failed to initialize AppContainer: \(error)"
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                repository: appContainer.productRepository,
                dataSyncService: appContainer.dataSyncService, networkMonitor: appContainer.networkMonitor,
                imageLoader: appContainer.imageLoader
            )
        }
    }
}
