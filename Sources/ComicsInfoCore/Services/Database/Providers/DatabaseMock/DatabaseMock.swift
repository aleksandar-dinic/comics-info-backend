//
//  DatabaseMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct DatabaseMock: Database {

    static var items = [String: Data]()

    static func removeAll() {
        DatabaseMock.items.removeAll()
    }

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger, items: [String: Data]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in items.enumerated() {
            DatabaseMock.items[el.key] = el.value
        }
    }

    func getItem<Item: Codable>(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        logger.log(level: .info, "GetItem withID: \(ID))")

        guard let data = DatabaseMock.items[ID],
              let item = try? JSONDecoder().decode(Item.self, from: data) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: ID))
        }
        
        return eventLoop.makeSucceededFuture(item)
    }
    
    func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]> {
        logger.log(level: .info, "GetItems withIDs: \(IDs))")
        
        var items = [Item]()
        for id in IDs {
            guard let data = DatabaseMock.items[id],
                  let item = try? JSONDecoder().decode(Item.self, from: data) else { continue }
            items.append(item)
        }

        guard items.count == IDs.count else {
            return eventLoop.makeFailedFuture(
                DatabaseError.itemsNotFound(withIDs: Set(items.map({ $0.itemID })).symmetricDifference(IDs))
            )
        }

        return eventLoop.makeSucceededFuture(items)
    }

    func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]> {
        logger.log(level: .info, "GetAll items: \(items))")

        var databaseItems = [Item]()
        for value in DatabaseMock.items.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemName == items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.makeSucceededFuture(databaseItems)
    }
    
    func getSummaries<Summary: ItemSummary>(_ itemName: String, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        logger.log(level: .info, "GetSummaries items: itemName = \(itemName), ID = \(ID)")
        
        var items = [Summary]()
        for (_, el) in DatabaseMock.items.enumerated() {
            guard el.key.hasSuffix(ID), let item = try? JSONDecoder().decode(Summary.self, from: el.value), item.itemName == itemName else { continue }
            items.append(item)
        }
        
        return eventLoop.makeSucceededFuture(!items.isEmpty ? items : nil)
    }

}
