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

    static var logger = AWSClient.loggingDisabled

    init(eventLoop: EventLoop, logger: Logger) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .default)
        DynamoDB.logger = logger
    }

}

// Read item.
extension DynamoDB {

    public func getItem(withID itemID: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemID": .s(itemID)],
            keyConditionExpression: "itemID = :itemID",
            tableName: tableName
        )

        DynamoDB.logger.log(level: .info, "GetItem input: \(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetItem output: \($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemNotFound(withID: itemID)
            }
            return items.map { DatabasePutItem($0, table: tableName) }
        }
    }

    public func getAll(_ items: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemName": .s(items)],
            indexName: "itemName-summaryID-index",
            keyConditionExpression: "itemName = :itemName",
            tableName: tableName
        )

        DynamoDB.logger.log(level: .info, "GetAll input: \(input)")
        return query(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetAll output: \($0)")
            guard let items = $0.items?.compactMap({ $0.compactMapValues { $0.value } }), !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items.map { DatabasePutItem($0, table: tableName) }
        }
    }

}

// Read item metadata.
extension DynamoDB {

    public func getMetadata(withID id: String, tableName: String) -> EventLoopFuture<DatabaseItem> {
        let input = GetItemInput(
            key: ["itemID": .s(id), "summaryID": .s(id)],
            tableName: tableName
        )

        DynamoDB.logger.log(level: .info, "GetMetadata input: \(input)")
        return getItem(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetMetadata output: \($0)")
            guard let item = $0.item?.compactMapValues({ $0.value }) else {
                throw DatabaseError.itemNotFound(withID: id)
            }
            return DatabasePutItem(item, table: tableName)
        }
    }

    public func getAllMetadata(withIDs ids: Set<String>, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        var keys = [[String: AttributeValue]]()

        for id in ids {
            keys.append(["itemID": .s(id), "summaryID": .s(id)])
        }

        let keysAndAttributes = KeysAndAttributes(keys: keys)

        let input = BatchGetItemInput(
            requestItems: [tableName: keysAndAttributes]
        )

        DynamoDB.logger.log(level: .info, "GetAllMetadata input: \(input)")
        return batchGetItem(input).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetAllMetadata output: \($0)")
            guard let items = $0.responses?[tableName]?.compactMap({ $0.compactMapValues { $0.value } }),
                  !items.isEmpty else {
                let ids = Set(ids.compactMap({ $0.split(separator: "#").last }).map { String($0) })
                throw DatabaseError.itemsNotFound(withIDs: ids)
            }
            return items.map { DatabasePutItem($0, table: tableName) }
        }
    }

}
