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

    mutating func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Create item: \(item))")

        guard DatabaseMock.items[item.itemID] == nil, let itemData = try? JSONEncoder().encode(item) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: item.itemID))
        }

        DatabaseMock.items[item.itemID] = itemData
        return eventLoop.submit { }
    }
    
    mutating func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        logger.log(level: .info, "CreateSummaries items: \(summaries))")
        
        for summary in summaries {
            let id = "\(summary.itemID)|\(summary.summaryID)"
            
            guard DatabaseMock.items[id] == nil, let summaryData = try? JSONEncoder().encode(summary) else {
                return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
            }
            
            DatabaseMock.items[id] = summaryData
        }
        
        return eventLoop.submit { }
    }

}
