//
//  SotoDynamoDBProvider.swift
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

    public func create(_ item: [String: Any], tableName table: String) -> EventLoopFuture<Void> {
        let input = PutItemInput(
            conditionExpression: "attribute_not_exists(identifier)",
            item: item.compactMapValues { ($0 as? AttributeValueMapper)?.attributeValue },
            tableName: table
        )

        return putItem(input).flatMapThrowing { _ in }
    }

    public func getAll(fromTable table: String) -> EventLoopFuture<[[String: Any]]?> {
        let input = ScanInput(tableName: table)

        return scan(input).flatMapThrowing {
            $0.items?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

    public func get(fromTable table: String, forID ID: String) -> EventLoopFuture<[String: Any]?> {
        let input = GetItemInput(
            key: ["identifier": .s(ID)],
            tableName: table
        )

        return getItem(input).flatMapThrowing {
            $0.item?.compactMapValues { $0.value }
        }
    }

}
