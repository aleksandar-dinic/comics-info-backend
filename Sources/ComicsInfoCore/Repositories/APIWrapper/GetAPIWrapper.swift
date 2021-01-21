//
//  GetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetAPIWrapper: ItemSummaryHandler {

    associatedtype Item: Identifiable

    var repositoryAPIService: RepositoryAPIService { get }
    var decoderService: DecoderService { get }

    func get(withID itemID: String, from table: String) -> EventLoopFuture<Item>
    func handleItem(_ items: [DatabaseItem], id: String) throws -> Item

    func handleDatabaseItem<DBItem: DatabaseDecodable>(_ items: [DatabaseItem], id: String) throws -> DBItem

}

extension GetAPIWrapper {

    func get(withID itemID: String, from table: String) -> EventLoopFuture<Item> {
        repositoryAPIService.getItem(withID: mapToDatabaseID(itemID, itemType: Item.self), from: table)
            .flatMapThrowing { try handleItem($0, id: itemID) }
            .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
    }

    private func mapToDatabaseID(_ itemID: String, itemType: Any.Type) -> String {
        "\(String.getType(from: itemType))#\(itemID)"
    }

    func handleDatabaseItem<DBItem: DatabaseDecodable>(_ items: [DatabaseItem], id: String) throws -> DBItem {
        var dbItem: DBItem?

        for item in items {
            guard dbItem == nil else { break }
            dbItem = try? decoderService.decode(from: item)
        }

        guard let item = dbItem else {
            throw APIError.itemNotFound(withID: id, itemType: Item.self)
        }

        return item
    }

}
