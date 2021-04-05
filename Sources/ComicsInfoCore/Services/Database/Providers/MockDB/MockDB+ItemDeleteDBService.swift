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
        eventLoop.submit { query.item }
    }
    
    func deleteSummaries<Summary: ItemSummary>(
        _ query: DeleteSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        eventLoop.submit { query.summaries }
    }

}
