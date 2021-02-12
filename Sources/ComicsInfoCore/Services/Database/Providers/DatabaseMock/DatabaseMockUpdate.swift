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

    init(eventLoop: EventLoop, logger: Logger, items: [String: Data]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in items.enumerated() {
            DatabaseMock.items[el.key] = el.value
        }
    }

    func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        logger.log(level: .info, "Update item: \(item))")
        
        guard let oldItemData = DatabaseMock.items[item.itemID],
              let oldItem = try? JSONDecoder().decode(Item.self, from: oldItemData),
              let itemData = try? JSONEncoder().encode(item) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: item.itemID))
        }
        
        DatabaseMock.items[item.itemID] = itemData
        return eventLoop.submit { item.updatedFields(old: oldItem) }
    }
    
    func updateSummaries<Summary: ItemSummary>(
        with criteria: [UpdateSummariesCriteria<Summary>]
    ) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Update Summaries")
        
        for criterion in criteria {
            logger.log(level: .info, "UpdateSummaries items: \(criterion.item))")
            
            guard let itemData = criterion.getData(oldData: DatabaseMock.items[criterion.ID]) else { continue }
            DatabaseMock.items[criterion.ID] = itemData
        }

        return eventLoop.submit { }
    }

}
