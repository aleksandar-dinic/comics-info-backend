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

struct DatabaseMock: DatabaseGet {

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
        
        return eventLoop.submit { item }
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

        return eventLoop.submit { items }
    }

    func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]> {
        logger.log(level: .info, "GetAll items: \(items))")

        var databaseItems = [Item]()
        for value in DatabaseMock.items.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemType == items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.submit { databaseItems }
    }
    
    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        logger.log(level: .info, "GetSummaries items: itemType = \(criteria.itemType), ID = \(criteria.ID)")
        
        var items = [Summary]()
        for (_, el) in DatabaseMock.items.enumerated() {
            guard criteria.isValidKey(el.key),
                  let item = try? JSONDecoder().decode(Summary.self, from: el.value),
                  item.itemType == criteria.itemType
            else { continue }
            items.append(item)
        }
        
        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
    func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        logger.log(level: .info, "Get Summary")
        
        var items = [Summary]()
        for criterion in criteria {
            guard let data = DatabaseMock.items["\(criterion.itemID)|\(criterion.summaryID)"],
                  let item = try? JSONDecoder().decode(Summary.self, from: data) else { continue }
            items.append(item)
        }

        return eventLoop.submit { !items.isEmpty ? items : nil }
    }

}
