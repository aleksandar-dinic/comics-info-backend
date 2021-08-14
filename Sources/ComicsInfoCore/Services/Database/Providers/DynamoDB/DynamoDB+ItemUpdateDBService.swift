//
//  DynamoDB+ItemUpdateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: ItemUpdateDBService {

    public func update<Item: ComicInfoItem>(_ query: UpdateItemQuery<Item>) -> EventLoopFuture<Item> {
        deleteItem(query.dynamoDBQuery.deleteInput).flatMap { _ in
            updateItem(query.dynamoDBQuery.input)
                .map { _ in query.item }
                .flatMapErrorThrowing {
                    print("Update ERROR: \($0)")
                    throw $0
                }
        }
    }
    
    public func updateSummaries<Summary: ItemSummary>(
        _ query: UpdateSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        var futures = [EventLoopFuture<Summary>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(
                deleteItem(input.0)
                    .flatMap { _ in
                        updateItem(input.1)
                            .map { _ in input.2 }
                            .flatMapErrorThrowing {
                                print("UpdateSummaries - UpdateItem ERROR: \($0)")
                                throw $0
                            }
                    }
                    .flatMapErrorThrowing {
                        print("UpdateSummaries - DeleteItem ERROR: \($0)")
                        throw $0
                    }
            )
        }

        return EventLoopFuture.reduce([], futures, on: client.eventLoopGroup.next()) { (items, item) in
            var items = items
            items.append(item)
            return items
        }
    }
    
}
