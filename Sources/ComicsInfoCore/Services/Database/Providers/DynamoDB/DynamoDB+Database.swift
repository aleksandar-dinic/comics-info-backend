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

extension DynamoDB: DatabaseGet {

    static var logger = AWSClient.loggingDisabled

    init(eventLoop: EventLoop, logger: Logger) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .getFromEnvironment())
        DynamoDB.logger = logger
    }

}

// Read item.
extension DynamoDB {

    public func getItem<Item: Codable>(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        let input = GetItemInput(
            key: ["itemID": .s(ID), "summaryID": .s(ID)],
            tableName: table
        )

        DynamoDB.logger.log(level: .info, "GetItem input: \(input)")
        return getItem(input, type: Item.self).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetItem output: \($0)")
            guard let item = $0.item else {
                throw DatabaseError.itemNotFound(withID: ID)
            }
            return item
        }
    }
    
    public func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]> {
        DynamoDB.logger.log(level: .info, "GetItems withIDs: \(IDs)")
        var futures = [EventLoopFuture<Item>]()
        
        for id in IDs {
            let input = GetItemInput(
                key: ["itemID": .s(id), "summaryID": .s(id)],
                tableName: table
            )
            
            DynamoDB.logger.log(level: .info, "GetItems input: \(input)")
            let future: EventLoopFuture<Item> = getItem(input, type: Item.self).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "GetItems output: \($0)")
                guard let item = $0.item else {
                    throw DatabaseError.itemNotFound(withID: id)
                }
                return item
            }
            futures.append(future)
        }

        let futureResult = EventLoopFuture.reduce([Item](), futures, on: client.eventLoopGroup.next()) { (items, item) in
            var items = items
            items.append(item)
            return items
        }
        return futureResult.flatMapThrowing { items in
            guard !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: IDs)
            }
            return items
        }
    }

    public func getAll<Item: Codable>(_ items: String, from table: String) -> EventLoopFuture<[Item]> {
        let input = QueryInput(
            expressionAttributeValues: [":itemName": .s(items)],
            indexName: "itemName-summaryID-index",
            keyConditionExpression: "itemName = :itemName",
            tableName: table
        )

        DynamoDB.logger.log(level: .info, "GetAll input: \(input)")
        return query(input, type: Item.self).flatMapThrowing {
            DynamoDB.logger.log(level: .info, "GetAll output: \($0)")
            guard let items = $0.items, !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }
    }
    
    public func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        let input = criteria.queryInput

        DynamoDB.logger.log(level: .info, "GetSummaries input:\(input)")
        return query(input, type: Summary.self).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "GetSummaries output: \($0)")
                guard let items = $0.items, !items.isEmpty else {
                    return nil
                }
                return items
            }
    }
    
    public func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        
        DynamoDB.logger.log(level: .info, "Get Summary")
        var futures = [EventLoopFuture<Summary?>]()
        
        for criterion in criteria {
            let input = GetItemInput(
                key: ["itemID": .s(criterion.itemID), "summaryID": .s(criterion.summaryID)],
                tableName: criterion.table
            )

            DynamoDB.logger.log(level: .info, "Get Summary input: \(input)")
            let future: EventLoopFuture<Summary?> = getItem(input, type: Summary.self).flatMapThrowing {
                DynamoDB.logger.log(level: .info, "Get Summary output: \($0)")
                return $0.item
            }
            futures.append(future)
        }

        let futureResult = EventLoopFuture.reduce([Summary](), futures, on: client.eventLoopGroup.next()) { (items, item) in
            guard let item = item else { return items }
            var items = items
            items.append(item)
            return items
        }
        
        return futureResult.map { !$0.isEmpty ? $0 : nil }
    }

}
