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
        deleteItem(query.dynamoDBQuery.input).map { _ in query.item }
    }
    
    func deleteSummaries<Summary: ItemSummary>(
        _ query: DeleteSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        var futures = [EventLoopFuture<Summary>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(deleteItem(input.0).map { _ in input.1 })
        }

        return EventLoopFuture.reduce([], futures, on: client.eventLoopGroup.next()) { (items, item) in
            var items = items
            items.append(item)
            return items
        }
    }

}
