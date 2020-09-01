//
//  DynamoDB+Database.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSDynamoDB
import AsyncHTTPClient
import Foundation

extension DynamoDB: Database {

    init(eventLoop: EventLoop) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .default)
    }

    func getAll(fromTable table: DatabaseTable) -> EventLoopFuture<[[String: Any]]?> {
        let input = DynamoDB.ScanInput(tableName: table.getName())

        return scan(input).flatMapThrowing { output in
            output.items?.compactMap { $0.compactMapValues { $0.value } }
        }
    }

    func get(fromTable table: DatabaseTable, forID ID: String) -> EventLoopFuture<[String: Any]?> {
        let input = DynamoDB.GetItemInput(
            key: [.identifier: .s(ID)],
            tableName: table.getName()
        )

        return getItem(input).flatMapThrowing { output in
            output.item?.compactMapValues { $0.value }
        }
    }

}
