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
    private static var logger = AWSClient.loggingDisabled

    init(eventLoop: EventLoop, tableName: String, logger: Logger) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .default)
        DynamoDB.tableName = tableName
        DynamoDB.logger = logger
    }

}

// Create item.
extension DynamoDB {

    public func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        let input = PutItemInput(
            conditionExpression: item.conditionExpression,
            item: item.attributeValues,
            tableName: item.table
        )

        DynamoDB.logger.log(level: .info, "\(input)")
        return putItem(input)
            .flatMapThrowing { DynamoDB.logger.log(level: .info, "\($0)") }
    }

    public func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
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
        DynamoDB.logger.log(level: .info, "\(input)")
        return transactWriteItems(input)
                .flatMapThrowing { DynamoDB.logger.log(level: .info, "\($0)") }
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

        DynamoDB.logger.log(level: .info, "\(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "\($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemNotFound(withID: itemID)
            }
            return items.map { DatabasePutItem($0, table: DynamoDB.tableName) }
        }
    }

    public func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemName": .s(items)],
            indexName: "itemName-summaryID-index",
            keyConditionExpression: "itemName = :itemName",
            tableName: DynamoDB.tableName
        )

        DynamoDB.logger.log(level: .info, "\(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "\($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items.map { DatabasePutItem($0, table: DynamoDB.tableName) }
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

        DynamoDB.logger.log(level: .info, "\(input)")
        return getItem(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "\($0)")
            guard let item = $0.item?.compactMapValues({ $0.value }) else {
                throw DatabaseError.itemNotFound(withID: id)
            }
            return DatabasePutItem(item, table: DynamoDB.tableName)
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

        DynamoDB.logger.log(level: .info, "\(input)")
        return batchGetItem(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "\($0)")
            guard let items = $0.responses?[DynamoDB.tableName]?.compactMap({ $0.compactMapValues { $0.value } }),
                  !items.isEmpty else {
                let ids = Set(ids.compactMap({ $0.split(separator: "#").last }).map { String($0) })
                throw DatabaseError.itemsNotFound(withIDs: ids)
            }
            return items.map { DatabasePutItem($0, table: DynamoDB.tableName) }
        }
    }

}

// Read summary.
extension DynamoDB {

    public func getAllSummaries(forID summaryID: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":summaryID": .s(summaryID)],
            indexName: "summaryID-itemID-index",
            keyConditionExpression: "summaryID = :summaryID",
            tableName: DynamoDB.tableName
        )

        DynamoDB.logger.log(level: .info, "\(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "\($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items.map { DatabasePutItem($0, table: DynamoDB.tableName) }
        }
    }

}

// Update item.
extension DynamoDB {

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

            let transactWriteItem = TransactWriteItem(update: update)
            transactItems.append(transactWriteItem)
        }

        let input = TransactWriteItemsInput(transactItems: transactItems)
        DynamoDB.logger.log(level: .info, "\(input)")
        return transactWriteItems(input)
                .flatMapThrowing { DynamoDB.logger.log(level: .info, "\($0)") }
    }

}
