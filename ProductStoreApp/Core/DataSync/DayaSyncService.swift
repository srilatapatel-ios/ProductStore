//
//  DayaSyncService.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import SwiftData

protocol DataSyncServicing {
    func syncPendingFavoriteChanges() async
}

final class DataSyncService: DataSyncServicing {
    
    private let dataStore: DataStoring
    private let networkService: NetworkRequestManaging
    private let networkMonitor: NetworkMonitoring
    
    init(
        dataStore: DataStoring,
        networkService: NetworkRequestManaging,
        networkMonitor: NetworkMonitoring
    ) {
        self.dataStore = dataStore
        self.networkService = networkService
        self.networkMonitor = networkMonitor
    }
    
    func syncPendingFavoriteChanges() async {
        let isConnected = await networkMonitor.isNetworkAvailable()
        guard isConnected else {
            return
        }
        do {
            let pendingChanges =
                try dataStore.fetchPendingFavoriteChanges()
            for change in pendingChanges {
                await sync(change)
            }
        } catch {
            print(
                "Failed to fetch pending changes: \(error)"
            )
        }
    }
    
    private func sync(_ change: FavoriteSyncDataEntity) async {
        do {
            change.status = SyncStatus.syncing.rawValue
            let request = FavoriteSyncRequest(
                productID: change.productID,
                isFavorite: change.isFavorite
            )
            let _: SyncResponse = try await networkService.post(
                url: Endpoint.syncFavorite.url,
                parameters: [:],
                body: request
            )
            change.status = SyncStatus.synced.rawValue
            try dataStore.markFavoriteSyncAsCompleted(change)
        } catch {
            change.status = SyncStatus.failed.rawValue
            change.retryCount += 1
            change.lastError = error.localizedDescription
            try? dataStore.saveChanges()
        }
    }
}

private extension DataSyncService {

    func markPendingChangesAsFailed(message: String) {
        do {
            let changes =
            try dataStore.fetchPendingFavoriteChanges()
            for change in changes {
                change.status = SyncStatus.failed.rawValue
                change.lastError = message
            }
            try dataStore.saveChanges()
        } catch {
            print("Failed to update sync status: \(error)")
        }
    }
}
