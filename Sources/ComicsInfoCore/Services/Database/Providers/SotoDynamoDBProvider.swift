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

    public func getAll(fromTable table: String) -> EventLoopFuture<[[String: Any]]?> {
        let input = DynamoDB.ScanInput(tableName: table)

        return scan(input).flatMapThrowing { output in
            output.items?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

    public func get(fromTable table: String, forID ID: String) -> EventLoopFuture<[String: Any]?> {
        let input = DynamoDB.GetItemInput(
            key: ["identifier": .s(ID)],
            tableName: table
        )

        return getItem(input).flatMapThrowing { output in
            output.item?.compactMapValues { $0.value }
        }
    }

}
