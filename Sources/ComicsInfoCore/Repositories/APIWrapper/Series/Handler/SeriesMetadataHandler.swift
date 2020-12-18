//
//  SeriesMetadataHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesMetadataHandler: EmptyItemsHandler {

    var seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> { get }

    func getSeries(_ seriesIDs: Set<String>?, from table: String) -> EventLoopFuture<[Series]>

}

extension SeriesMetadataHandler {

    func getSeries(_ seriesIDs: Set<String>?, from table: String) -> EventLoopFuture<[Series]> {
        guard let seriesIDs = seriesIDs, !seriesIDs.isEmpty else {
            return handleEmptyItems()
        }

        return seriesUseCase.getAllMetadata(withIDs: seriesIDs, fromDataSource: .memory, from: table)
                .flatMapThrowing { try handleItems($0, itemsID: seriesIDs) }
    }

    private func handleItems<Item: Identifiable>(_ items: [Item], itemsID: Set<Item.ID>) throws -> [Item] where Item.ID == String {
        let ids = Set(items.map { $0.id })
        for id in itemsID {
            guard !ids.contains(id) else { continue }
            throw APIError.itemNotFound(withID: id, itemType: Item.self)
        }
        return items
    }

}
