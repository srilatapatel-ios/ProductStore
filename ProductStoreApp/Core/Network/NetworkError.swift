//
//  NetworkError.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case encodingError(Error)
    case decodingError(Error)
    case requestFailed(Error)
}
