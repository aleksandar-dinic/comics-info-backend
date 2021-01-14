//
//  DatabaseMockCreate.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct DatabaseMockCreate: DatabaseCreate {

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger) {
        self.eventLoop = eventLoop
        self.logger = logger
    }

    mutating func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Create item: \(item))")

        guard let itemID = item["itemID"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
        }

        guard let summaryID = item["summaryID"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
        }

        let id = "\(itemID)|\(summaryID)"
        guard DatabaseMock.items[id] == nil else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
        }
        
        DatabaseMock.items[id] = TableMock(id: id, attributes: item.attributeValues)
        return eventLoop.makeSucceededFuture(())
    }

    mutating func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "CreateAll items: \(items))")

        for item in items {
            guard let itemID = item["itemID"] as? String else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
            }

            guard let summaryID = item["summaryID"] as? String else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
            }

            let id = "\(itemID)|\(summaryID)"
            guard DatabaseMock.items[id] == nil else {
                return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
            }
            
            DatabaseMock.items[id] = TableMock(id: id, attributes: item.attributeValues)
        }

        return eventLoop.makeSucceededFuture(())
    }

}
