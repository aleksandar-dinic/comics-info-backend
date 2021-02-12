//
//  DynamoDB+DatabaseUpdate.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import Foundation
import SotoDynamoDB

extension DynamoDB: DatabaseUpdate {

    public func update<Item: Codable & Identifiable>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        let input = UpdateItemCodableInput(
            conditionExpression: "attribute_exists(itemID) AND attribute_exists(summaryID)",
            key: ["itemID", "summaryID"],
            returnValues: .updatedOld,
            tableName: table,
            updateItem: item
        )

        DynamoDB.logger.log(level: .info, "Update input: \(input)")
        return updateItem(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "Update output: \($0)")
            guard let keys = $0.attributes?.keys else { return [] }
            return Set(keys)
        }
    }
    
    public func updateSummaries<Summary: ItemSummary>(
        with criteria: [UpdateSummariesCriteria<Summary>]
    ) -> EventLoopFuture<Void> {
        DynamoDB.logger.log(level: .info, "Update Summaries")
        var futures = [EventLoopFuture<Void>]()
        
        for criterion in criteria {
            let input = criterion.updateInput
            
            DynamoDB.logger.log(level: .info, "Update Summaries: \(input)")
            let future = updateItem(input).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "Update Summaries output: \($0)")
            }
            futures.append(future)
        }

        return EventLoopFuture.reduce((), futures, on: client.eventLoopGroup.next()) { (_, _) in }
    }
    
}
