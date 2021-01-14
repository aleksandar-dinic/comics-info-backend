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

    public func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        var transactItems = [TransactWriteItem]()

        for item in items {
            let update = Update(
                conditionExpression: item.conditionExpression,
                expressionAttributeNames: item.attributeNames,
                expressionAttributeValues: item.attributeValues,
                key: item.key,
                tableName: item.table,
                updateExpression: item.updateExpression
            )

            transactItems.append(.update(update))
        }

        let input = TransactWriteItemsInput(transactItems: transactItems)
        DynamoDB.logger.log(level: .info, "Update input: \(input)")
        return transactWriteItems(input)
                .flatMapThrowing {
                    DynamoDB.logger.log(level: .info, "Update output: \($0)")
                }
    }
    
    public func getAllSummaries(forID summaryID: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":summaryID": .s(summaryID)],
            indexName: "summaryID-itemID-index",
            keyConditionExpression: "summaryID = :summaryID",
            tableName: tableName
        )

        DynamoDB.logger.log(level: .info, "GetAllSummaries input:\(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetAllSummaries output: \($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0 } }), !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items.map { DatabaseGetItem($0, table: tableName) }
        }
    }

}
