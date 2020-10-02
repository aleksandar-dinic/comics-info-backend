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

    private static var tableName = ""

    init(eventLoop: EventLoop, tableName: String) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .default)
        DynamoDB.tableName = tableName
    }

}

// Create item.
extension DynamoDB {

    public func create(_ item: DatabaseItem) -> EventLoopFuture<Void> {
        let input = PutItemInput(
            conditionExpression: item.conditionExpression,
            item: item.attributeValues,
            tableName: item.table
        )

        return putItem(input).flatMapThrowing { _ in }
    }

    public func createAll(_ items: [DatabaseItem]) -> EventLoopFuture<Void> {
        var transactItems = [TransactWriteItem]()

        for item in items {
            let put = Put(
                conditionExpression: item.conditionExpression,
                item: item.attributeValues,
                tableName: item.table
            )

            let transactWriteItem = TransactWriteItem(put: put)
            transactItems.append(transactWriteItem)
        }

        let input = TransactWriteItemsInput(transactItems: transactItems)
        return transactWriteItems(input).flatMapThrowing { _ in }
    }

}

// Read item.
extension DynamoDB {

    public func getItem(withID itemID: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemID": .s(itemID)],
            keyConditionExpression: "itemID = :itemID",
            tableName: DynamoDB.tableName
        )

        return query(input).flatMapThrowing {
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemNotFound(withID: itemID)
            }
            return items.map { DatabaseItem($0, table: DynamoDB.tableName) }
        }
    }

    public func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemName": .s(items)],
            indexName: "itemName-summaryID-index",
            keyConditionExpression: "itemName = :itemName",
            tableName: DynamoDB.tableName
        )

        return query(input).flatMapThrowing {
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items.map { DatabaseItem($0, table: DynamoDB.tableName) }
        }
    }

}

// Read item metadata.
extension DynamoDB {

    public func getMetadata(withID id: String) -> EventLoopFuture<DatabaseItem> {
        let input = GetItemInput(
            key: ["itemID": .s(id), "summaryID": .s(id)],
            tableName: DynamoDB.tableName
        )

        return getItem(input).flatMapThrowing {
            guard let item = $0.item?.compactMapValues({ $0.value }) else {
                throw DatabaseError.itemNotFound(withID: id)
            }
            return DatabaseItem(item, table: DynamoDB.tableName)
        }
    }

    public func getAllMetadata(withIDs ids: Set<String>) -> EventLoopFuture<[DatabaseItem]> {
        var keys = [[String: AttributeValue]]()

        for id in ids {
            keys.append(["itemID": .s(id), "summaryID": .s(id)])
        }

        let keysAndAttributes = KeysAndAttributes(keys: keys)

        let input = BatchGetItemInput(
            requestItems: [DynamoDB.tableName: keysAndAttributes]
        )

        return batchGetItem(input).flatMapThrowing {
            guard let items = $0.responses?[DynamoDB.tableName]?.compactMap({ $0.compactMapValues { $0.value } }),
                  !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: ids)
            }
            return items.map { DatabaseItem($0, table: DynamoDB.tableName) }
        }
    }

}
