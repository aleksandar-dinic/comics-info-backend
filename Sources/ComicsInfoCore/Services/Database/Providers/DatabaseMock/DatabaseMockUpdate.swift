//
//  DatabaseMockUpdate.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct DatabaseMockUpdate: DatabaseUpdate {

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger, tables: [String: TableMock]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in tables.enumerated() {
            for item in el.value.items {
                DatabaseMock.tables[el.key, default: TableMock(name: el.key)].items[item.key] = item.value
            }
        }
    }

    func getAllSummaries(forID summaryID: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetAllSummaries summaryID: \(summaryID))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: summaryID))
        }

        return eventLoop.makeSucceededFuture(items.filter { ($0.attributes["summaryID"] as? String) == summaryID } )
    }

    mutating func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Update items: \(items))")

        for item in items {
            guard let itemID = item.key["itemID"]?.value else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
            }

            guard let summaryID = item.key["summaryID"]?.value else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
            }

            let id = "\(itemID)|\(summaryID)"

            guard
                item.conditionExpression == nil ||
                DatabaseMock.tables[item.table]?.items.keys.contains(id) ?? false else {
                return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
            }

            let updatedItem = DatabasePutItem(item.attributes, table: item.table)
            DatabaseMock.tables[item.table, default: TableMock(name: item.table)].items[id] = updatedItem
        }

        return eventLoop.makeSucceededFuture(())
    }

}
