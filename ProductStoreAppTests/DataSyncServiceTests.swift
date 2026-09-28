//
//  DataSyncServiceTests.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 27/09/26.
//

import XCTest
@testable import ProductStoreApp

@MainActor
final class DataSyncServiceTests: XCTestCase {

    func testSyncPendingFavoriteChanges_whenNetworkAvailable_syncsPendingChange() async {

        let mockDataStore = MockDataStore()
        let mockNetworkService = MockNetworkService()
        let mockNetworkMonitor = MockNetworkMonitor()

        // Create pending favorite change
        let change = FavoriteSyncDataEntity(productID: 1, isFavorite: true)
        mockDataStore.pendingChanges = [change]
        let service = DataSyncService(
            dataStore: mockDataStore,
            networkService: mockNetworkService,
            networkMonitor: mockNetworkMonitor
        )
        await service.syncPendingFavoriteChanges()
        XCTAssertEqual(mockNetworkService.postCallCount, 1)
        XCTAssertEqual(change.status, SyncStatus.synced.rawValue)
        XCTAssertEqual(mockDataStore.completedChanges.count, 1)
    }
    
    func testSyncPendingFavoriteChanges_whenNetworkFails_marksChangeAsFailed() async {
        let mockDataStore = MockDataStore()
        let mockNetworkService = MockNetworkService()
        let mockNetworkMonitor = MockNetworkMonitor()
        mockNetworkService.shouldFail = true
        let change = FavoriteSyncDataEntity(productID: 1, isFavorite: true)
        mockDataStore.pendingChanges = [change]
        let service = DataSyncService(
            dataStore: mockDataStore,
            networkService: mockNetworkService,
            networkMonitor: mockNetworkMonitor
        )
        await service.syncPendingFavoriteChanges()
        XCTAssertEqual(mockNetworkService.postCallCount, 1)
        XCTAssertEqual(change.status, SyncStatus.failed.rawValue)
        XCTAssertEqual(change.retryCount, 1)
        XCTAssertNotNil(change.lastError)
        XCTAssertEqual(mockDataStore.saveChangesCallCount, 1)
    }
}
