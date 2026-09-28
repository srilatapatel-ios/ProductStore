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
    @ObservationIgnored
    private var monitor: NWPathMonitor?
    @ObservationIgnored
    private var monitoringTask: Task<Void, Never>?
    @ObservationIgnored
    private var wakeContinuation: AsyncStream<Void>.Continuation?
    private let checkInterval: Duration = .seconds(15)
    
    func startMonitoring() {
        guard monitoringTask == nil else {
            return
        }
        
        let (stream, continuation) = AsyncStream<Void>.makeStream(bufferingPolicy: .bufferingNewest(1))
        wakeContinuation = continuation
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { _ in
            continuation.yield()
        }
        
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
        self.monitor = monitor
        monitoringTask = Task { [weak self] in
            await self?.check()
            await withTaskGroup(of: Void.self) { group in
                // Check immediately when NWPathMonitor reports a change.
                group.addTask {
                    for await _ in stream {
                        guard !Task.isCancelled else { return }
                        await self?.check()
                    }
                }
                group.addTask {
                    while !Task.isCancelled {
                        try? await Task.sleep(for: self?.checkInterval ?? .seconds(15))
                        guard !Task.isCancelled else { return }
                        await self?.check()
                    }
                }
            }
        }
    }
    
    func stopMonitoring() {
        monitoringTask?.cancel()
        monitoringTask = nil
        
        wakeContinuation?.finish()
        wakeContinuation = nil
        
        monitor?.cancel()
        monitor = nil
    }
    
    func isNetworkAvailable() async -> Bool {
        await check()
        return isConnected
    }
    
    private func check() async {
        let reachable = await Self.probeConnectivity()
        guard isConnected != reachable else { return }
        print("🌐 Network status:", reachable ? "CONNECTED" : "OFFLINE")
        isConnected = reachable
    }
    
    nonisolated private static func probeConnectivity() async -> Bool {
        guard let url = URL(
            string: "https://www.apple.com/library/test/success.html"
        ) else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 3
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForRequest = 3
        let session = URLSession(configuration: configuration)
        defer {
            session.invalidateAndCancel()
        }
        do {
            let (_, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            return (200...299).contains(httpResponse.statusCode)
        } catch {
            return false
        }
    }
    
    deinit {
        monitor?.cancel()
    }
}
protocol NetworkMonitoring: AnyObject, Sendable {
    func isNetworkAvailable() async -> Bool
}
