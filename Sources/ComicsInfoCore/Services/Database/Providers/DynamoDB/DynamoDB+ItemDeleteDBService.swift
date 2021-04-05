//
//  DynamoDB+ItemDeleteDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: ItemDeleteDBService {
    
    func delete<Item: ComicInfoItem>(_ query: DeleteItemQuery<Item>) -> EventLoopFuture<Item> {
        client.eventLoopGroup.next().submit { query.item }
    }
    
    func deleteSummaries<Summary: ItemSummary>(
        _ query: DeleteSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        client.eventLoopGroup.next().submit { query.summaries }
    }

}
