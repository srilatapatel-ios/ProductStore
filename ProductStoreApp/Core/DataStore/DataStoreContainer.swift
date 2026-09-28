//
//  DataStoreContainer.swift
//  ProductStoreApp
//
//  Created by Shri lata Patel on 25/09/26.
//

import Foundation
import SwiftData

final class DataStoreContainer {

    let container: ModelContainer

    init() throws {
        container = try ModelContainer(for: ProductDataEntity.self, FavoriteSyncDataEntity.self)
    }

    var mainContext: ModelContext {
        container.mainContext
    }
}
