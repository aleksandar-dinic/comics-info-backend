//
//  MockDB+ItemDeleteDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

extension MockDB: ItemDeleteDBService {
    
    func delete<Item: ComicInfoItem>(_ query: DeleteItemQuery<Item>) -> EventLoopFuture<Item> {
        guard MockDB[query.id] != nil else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: query.item.itemID))
        }

        MockDB[query.id] = nil
        return eventLoop.submit { query.item }
    }
    
    func deleteSummaries<Summary: ItemSummary>(
        _ query: DeleteSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        var ids = Set<String>()
        var missingIDs = Set<String>()
        
        for summary in query.summaries {
            let id = query.getID(for: summary)
            
            if MockDB[id] != nil {
                ids.insert(id)
            } else {
                missingIDs.insert(id)
            }
        }
        
        guard missingIDs.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: missingIDs))
        }
        
        for id in ids {
            MockDB[id] = nil
        }
        
        return eventLoop.submit { query.summaries }
    }

}
