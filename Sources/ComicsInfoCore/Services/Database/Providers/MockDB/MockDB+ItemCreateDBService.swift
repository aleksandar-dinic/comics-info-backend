//
//  MockDB+ItemCreateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

extension MockDB: ItemCreateDBService {

    func create<Item: ComicInfoItem>(_ query: CreateItemQuery<Item>) -> EventLoopFuture<Item> {
        let mockQuery = query.mockDBQuery

        guard MockDB[mockQuery.id] == nil,
              let itemData = try? JSONEncoder().encode(mockQuery.item) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: mockQuery.id))
        }

        MockDB[mockQuery.id] = itemData
        return eventLoop.submit { mockQuery.item }
    }

    func createSummaries<Summary: ItemSummary>(
        _ query: CreateSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        for summary in query.summaries {
            let id = "\(summary.itemID)|\(summary.summaryID)"
            
            guard MockDB[id] == nil, let summaryData = try? JSONEncoder().encode(summary) else {
                return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
            }
            
            MockDB[id] = summaryData
        }
        
        return eventLoop.submit { query.summaries }
    }

}
