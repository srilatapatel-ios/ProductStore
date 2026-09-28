//
//  NetworkMonitor.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 28/09/26.
//

import Foundation
import Network

@MainActor
@Observable
final class NetworkMonitor: NetworkMonitoring {
    
    private(set) var isConnected = true
    var onConnectionRestored: (() -> Void)?
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            print("Network status:", connected ? "CONNECTED" : "OFFLINE")
            Task { @MainActor in
                guard let self else { return }
                // Remember the previous state
                let wasDisconnected = !self.isConnected
                // Update current state
                self.isConnected = connected
                // Connection changed from OFFLINE → ONLINE
                if wasDisconnected && connected {
                    print("🔄 Connection restored")
                    self.onConnectionRestored?()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // Required by NetworkMonitoring
    func isNetworkAvailable() async -> Bool {
        isConnected
    }
    
    deinit {
        monitor.cancel()
    }
}

protocol NetworkMonitoring: AnyObject, Sendable {
    func isNetworkAvailable() async -> Bool
}
