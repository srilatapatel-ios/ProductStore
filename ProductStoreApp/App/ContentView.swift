//
//  ContentView.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import SwiftUI

struct ContentView: View {

    let repository: ProductRepository
    let dataSyncService: DataSyncService
    let networkMonitor: NetworkMonitor
    let imageLoader: ImageLoader

    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
                OfflineBanner()
            }
            TabView {
                NavigationStack {
                    ProductListView(repository: repository, imageLoader: imageLoader)
                }
                .tabItem {
                    Label("Products", systemImage: "bag")
                }
                NavigationStack {
                    FavouritesListView(repository: repository,
                                       dataSyncService: dataSyncService,
                                       imageLoader: imageLoader)
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            }
        }
    }
}
