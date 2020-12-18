//
//  ComicsMetadataHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicsMetadataHandler: EmptyItemsHandler {

    var comicUseCase: ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> { get }

    func getComics(_ comicsID: Set<String>?, from table: String) -> EventLoopFuture<[Comic]>

}

extension ComicsMetadataHandler {

    func getComics(_ comicsID: Set<String>?, from table: String) -> EventLoopFuture<[Comic]> {
        guard let comicsID = comicsID, !comicsID.isEmpty else {
            return handleEmptyItems()
        }

        return comicUseCase.getAllMetadata(withIDs: comicsID, fromDataSource: .memory, from: table)
                .flatMapThrowing { try handleItems($0, itemsID: comicsID) }
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
