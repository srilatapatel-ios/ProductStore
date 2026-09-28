//
//  EndPoint.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation

enum Endpoint {

    case products
    case syncFavorite

    var url: URL {
        switch self {
        case .products:
            return URL(
                string: "https://dummyjson.com/products"
            )!
        case .syncFavorite:
            return URL(
                string: "https://jsonplaceholder.typicode.com/posts"
            )!
        }
    }
}
