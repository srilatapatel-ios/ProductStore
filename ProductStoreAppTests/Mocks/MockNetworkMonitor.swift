//
//  MockNetworkMonitor.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 27/09/26.
//

@testable import ProductStoreApp
import Foundation

@MainActor
final class MockNetworkMonitor: NetworkMonitoring {

    var isConnected = true

    func isNetworkAvailable() async -> Bool {
        isConnected
    }
}
