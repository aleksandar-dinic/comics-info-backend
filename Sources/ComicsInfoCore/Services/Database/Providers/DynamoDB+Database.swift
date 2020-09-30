//
//  DynamoDB+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import Foundation
import SotoDynamoDB

extension DynamoDB: Database {

    init(eventLoop: EventLoop) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .default)
    }

}

// Create item.
extension DynamoDB {

    // FIXME: - Find a better way of setting a value `conditionExpression`
    public func create(_ item: [String: Any], tableName table: String) -> EventLoopFuture<Void> {
        let input = PutItemInput(
            conditionExpression: "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)",
            item: item.compactMapValues { ($0 as? AttributeValueMapper)?.attributeValue },
            tableName: table
        )

        return putItem(input).flatMapThrowing { _ in }
    }

    public func createAll(_ items: [String: [[String: Any]]]) -> EventLoopFuture<Void> {
        var transactItems = [TransactWriteItem]()
        for item in items {
            for value in item.value {
                let put = Put(
                    conditionExpression: "attribute_not_exists(itemID) AND attribute_not_exists(summaryID)",
                    item: value.compactMapValues { ($0 as? AttributeValueMapper)?.attributeValue },
                    tableName: item.key
                )

                let transactWriteItem = TransactWriteItem(put: put)
                transactItems.append(transactWriteItem)
            }
        }
        let input = TransactWriteItemsInput(transactItems: transactItems)
        return transactWriteItems(input).flatMapThrowing { _ in }
    }

}

// Read item.
extension DynamoDB {

    public func getItem(fromTable table: String, itemID: String) -> EventLoopFuture<[[String: Any]]?> {
        let input = QueryInput(
            expressionAttributeValues: [":itemID": itemID.attributeValue],
            keyConditionExpression: "itemID = :itemID",
            tableName: table
        )

        return query(input).flatMapThrowing {
            $0.items?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

    public func getAllItems(fromTable table: String) -> EventLoopFuture<[[String: Any]]?> {
        let input = ScanInput(tableName: table)

        return scan(input).flatMapThrowing {
            $0.items?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

}

// Read item metadata.
extension DynamoDB {

    public func getMetadata(fromTable table: String, id: String) -> EventLoopFuture<[String: Any]?> {
        let input = GetItemInput(
            key: ["itemID": .s(id), "summaryID": .s(id)],
            tableName: table
        )

        return getItem(input).flatMapThrowing {
            $0.item?.compactMapValues { $0.value }
        }
    }

    public func getAllMetadata(fromTable table: String, ids: Set<String>) -> EventLoopFuture<[[String: Any]]?> {
        var keys = [[String: AttributeValue]]()

        for id in ids {
            keys.append(["itemID": .s(id), "summaryID": .s(id)])
        }

        let keysAndAttributes = KeysAndAttributes(keys: keys)

        let input = BatchGetItemInput(
            requestItems: [table: keysAndAttributes]
        )

        return batchGetItem(input).flatMapThrowing { [table] in
            return $0.responses?[table]?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

}
