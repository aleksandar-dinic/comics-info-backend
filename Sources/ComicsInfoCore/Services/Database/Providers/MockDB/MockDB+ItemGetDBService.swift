//
//  MockDB+ItemGetDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

extension MockDB: ItemGetDBService {

    func getItem<Item: Codable>(_ query: GetItemQuery) -> EventLoopFuture<Item> {
        guard let data = MockDB[query.ID],
              let item = try? JSONDecoder().decode(Item.self, from: data) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: query.ID))
        }
        return eventLoop.submit { item }
    }
    
    func getItems<Item: ComicInfoItem>(_ query: GetItemsQuery) -> EventLoopFuture<[Item]> {
        var items = [Item]()
        for id in query.IDs {
            guard let data = MockDB[id],
                  let item = try? JSONDecoder().decode(Item.self, from: data) else { continue }
            items.append(item)
        }

        guard items.count == query.IDs.count else {
            return eventLoop.makeFailedFuture(
                DatabaseError.itemsNotFound(withIDs: Set(items.map({ $0.itemID })).symmetricDifference(query.IDs))
            )
        }

        return eventLoop.submit { items }
    }

    func getAll<Item: ComicInfoItem>(_ query: GetAllItemsQuery<Item>) -> EventLoopFuture<[Item]> {
        var databaseItems = [Item]()
        for value in MockDB.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemType == query.items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.submit { databaseItems }
    }
    
    func getSummaries<Summary: ItemSummary>(_ query: GetSummariesQuery) -> EventLoopFuture<[Summary]?> {
        var items = [Summary]()
        for (_, el) in MockDB.enumerated {
            guard query.isValidKey(el.key),
                  let item = try? JSONDecoder().decode(Summary.self, from: el.value),
                  item.itemType == query.itemType
            else { continue }
            items.append(item)
        }
        
        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
    func getSummary<Summary: ItemSummary>(_ query: GetSummaryQuery) -> EventLoopFuture<[Summary]?> {
        var items = [Summary]()
        for item in query.items {
            guard let data = MockDB["\(item.itemID)|\(item.summaryID)"],
                  let item = try? JSONDecoder().decode(Summary.self, from: data) else { continue }
            items.append(item)
        }

        return eventLoop.submit { !items.isEmpty ? items : nil }
    }

}
