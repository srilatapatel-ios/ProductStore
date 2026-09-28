//
//  NetworkService.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

protocol NetworkRequestManaging {
    
    func get<T: Decodable>(url: URL, parameters: [String: String]) async throws -> T
    
    func post<T: Decodable, U: Encodable>(url: URL, parameters: [String: String], body: U) async throws -> T
    
}

enum APIType {
    case ecs
    case graphQL
}

final class NetworkService: NetworkRequestManaging {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func makeURL(url: URL, parameters: [String: String]) throws -> URL {
        guard !parameters.isEmpty else {
            return url
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL
        }
        return finalURL
    }
    
    func get<T: Decodable>(url: URL, parameters: [String: String]) async throws -> T {
        let url = try makeURL(url: url, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return try await performRequest(request, responseType: T.self)
    }
    
    func post<T: Decodable, U: Encodable>(url: URL, parameters: [String: String], body: U) async throws -> T {
        let url = try makeURL(url: url, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)
        return try await performRequest(request, responseType: T.self)
    }
}

private extension NetworkService {
    
    func performRequest<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(statusCode: httpResponse.statusCode)
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
