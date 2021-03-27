//
//  MockDB+ItemUpdateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

extension MockDB: ItemUpdateDBService {

    func update<Item: ComicInfoItem>(_ query: UpdateItemQuery<Item>) -> EventLoopFuture<Item> {
        guard let itemData = try? JSONEncoder().encode(query.item) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: query.id))
        }
        
        MockDB[query.id] = itemData
        return eventLoop.submit { query.item }
    }
    
    func updateSummaries<Summary: ItemSummary>(_ query: UpdateSummariesQuery<Summary>) -> EventLoopFuture<[Summary]> {
        for summary in query.summaries {
            guard let itemData = try? JSONEncoder().encode(summary) else { continue }
            MockDB[query.getID(for: summary)] = itemData
        }

        return eventLoop.submit { query.summaries }
    }

}
