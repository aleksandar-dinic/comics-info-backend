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

    public func update<Item: ComicInfoItem>(_ query: UpdateItemQuery<Item>) -> EventLoopFuture<Set<String>> {
        updateItem(query.dynamoDBQuery.input).flatMapThrowing {
            guard let keys = $0.attributes?.keys else { return [] }
            return Set(keys)
        }
    }
    
    public func updateSummaries<Summary: ItemSummary>(
        _ query: UpdateSummariesQuery<Summary>
    ) -> EventLoopFuture<Void> {
        var futures = [EventLoopFuture<Void>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(updateItem(input).map { _ in })
        }

        return EventLoopFuture.reduce((), futures, on: client.eventLoopGroup.next()) { (_, _) in }
    }
    
}
