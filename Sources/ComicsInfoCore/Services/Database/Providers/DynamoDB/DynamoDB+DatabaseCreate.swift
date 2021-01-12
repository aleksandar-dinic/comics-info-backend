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

    public func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        let input = PutItemInput(
            conditionExpression: item.conditionExpression,
            item: item.attributeValues,
            tableName: item.table
        )

        DynamoDB.logger.log(level: .info, "Create input: \(input)")
        return putItem(input)
            .flatMapThrowing {
                DynamoDB.logger.log(level: .info, "Create output: \($0)")
            }
    }

    public func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
        var transactItems = [TransactWriteItem]()

        for item in items {
            let put = Put(
                conditionExpression: item.conditionExpression,
                item: item.attributeValues,
                tableName: item.table
            )

            transactItems.append(.put(put))
        }

        let input = TransactWriteItemsInput(transactItems: transactItems)
        DynamoDB.logger.log(level: .info, "CreateAll input: \(input)")
        return transactWriteItems(input)
                .flatMapThrowing {
                    DynamoDB.logger.log(level: .info, "CreateAll output: \($0)")
                }
    }

}
