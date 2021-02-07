//
//  DynamoDB+DatabaseCreate.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import Foundation
import SotoDynamoDB

extension DynamoDB: DatabaseCreate {

    public func create<Item: Codable>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        let input = PutItemCodableInput(
            conditionExpression: "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)",
            item: item,
            tableName: table
        )

        DynamoDB.logger.log(level: .info, "Create input: \(input)")
        return putItem(input).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "Create output: \($0)")
            }
    }
    
    public func createSummaries<Summary: Codable>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        DynamoDB.logger.log(level: .info, "Create Summaries")
        var futures = [EventLoopFuture<Void>]()
        
        for summary in summaries {
            let input = PutItemCodableInput(
                item: summary,
                tableName: table
            )
            
            DynamoDB.logger.log(level: .info, "Create Summaries input: \(input)")
            let future = putItem(input).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "Create Summaries output: \($0)")
            }
            futures.append(future)
        }

        return EventLoopFuture.reduce((), futures, on: client.eventLoopGroup.next()) { (_, _) in }
    }

}
