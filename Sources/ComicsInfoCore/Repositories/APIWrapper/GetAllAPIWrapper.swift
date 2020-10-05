//
//  GetAllAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetAllAPIWrapper: CharactersSummaryHandler, SeriesSummaryHandler, ComicsSummaryHandler {

    associatedtype Item: Identifiable

    var repositoryAPIService: RepositoryAPIService { get }
    var decoderService: DecoderService { get }

    func getAll() -> EventLoopFuture<[Item]>

    func handleItems(_ items: [DatabaseItem]) throws -> [Item]

}

extension GetAllAPIWrapper {

    func getAll() -> EventLoopFuture<[Item]> {
        repositoryAPIService.getAll(.getType(from: Item.self))
            .flatMapThrowing { try handleItems($0) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    func handleDatabaseItems<DBItem: DatabaseDecodable>(_ items: [DatabaseItem]) throws -> [String: DBItem] {
        var dbItems = [String: DBItem]()

        for item in items {
            guard let dbItem: DBItem = try? decoderService.decode(from: item) else { continue }
            dbItems[dbItem.itemID] = dbItem
        }

        guard !dbItems.isEmpty else {
            throw APIError.itemsNotFound(withIDs: nil, itemType: Item.self)
        }

        return dbItems
    }

}
