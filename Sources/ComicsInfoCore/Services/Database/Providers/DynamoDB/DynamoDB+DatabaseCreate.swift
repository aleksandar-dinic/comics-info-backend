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
        let input = PutItemCodableInput(
            item: summaries,
            tableName: table
        )

        DynamoDB.logger.log(level: .info, "CreateSummaries input: \(input)")
        return putItem(input).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "CreateSummaries output: \($0)")
            }
    }

}
