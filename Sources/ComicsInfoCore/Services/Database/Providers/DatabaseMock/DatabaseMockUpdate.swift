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

    init(eventLoop: EventLoop, logger: Logger, items: [String: TableMock]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in items.enumerated() {
            DatabaseMock.items[el.key] = el.value
        }
    }

    func getAllSummaries(forID summaryID: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetAllSummaries summaryID: \(summaryID))")

        var items = [DatabaseItem]()
        for key in DatabaseMock.items.keys where key.hasSuffix(summaryID) {
            guard let item = DatabaseMock.items[key] else { continue }
            items.append(DatabasePutItem(item.getAllAttributes(), table: tableName))
        }

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

            guard item.conditionExpression == nil || DatabaseMock.items[id] != nil else {
                return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
            }

            DatabaseMock.items[id] = TableMock(id: id, attributes: item.attributeValues)
        }

        return eventLoop.makeSucceededFuture(())
    }

}
