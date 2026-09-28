//
//  MockNetworkService.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 27/09/26.
//

import Foundation
@testable import ProductStoreApp

final class MockNetworkService: NetworkRequestManaging {

    var postCallCount = 0
    var shouldFail = false

    func post<T, U>(url: URL, parameters: [String: String], body: U) async throws -> T
    where T: Decodable, U: Encodable {
        postCallCount += 1
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        return SyncResponse(id: 1) as! T
    }

    func get<T: Decodable>(url: URL, parameters: [String: String]) async throws -> T {
        fatalError("GET is not used in DataSyncService tests")
    }
}
