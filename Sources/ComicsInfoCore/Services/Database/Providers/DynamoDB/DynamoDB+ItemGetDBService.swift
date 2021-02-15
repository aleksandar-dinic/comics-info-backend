//
//  DynamoDB+ItemGetDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: ItemGetDBService {

    func getItem<Item: Codable>(_ query: GetItemQuery) -> EventLoopFuture<Item> {
        getItem(query.dynamoDBQuery.input, type: Item.self).flatMapThrowing {
            guard let item = $0.item else {
                throw DatabaseError.itemNotFound(withID: query.dynamoDBQuery.ID)
            }
            return item
        }
    }
    
    func getItems<Item: ComicInfoItem>(_ query: GetItemsQuery) -> EventLoopFuture<[Item]> {
        var futures = [EventLoopFuture<Item>]()
        
        for (id, input) in query.dynamoDBQuery.inputs {
            let future: EventLoopFuture<Item> = getItem(input, type: Item.self).flatMapThrowing {
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
                throw DatabaseError.itemsNotFound(withIDs: query.dynamoDBQuery.IDs)
            }
            return items
        }
    }

    func getAll<Item: Codable>(_ query: GetAllItemsQuery) -> EventLoopFuture<[Item]> {
        self.query(query.dynamoDBQuery.input, type: Item.self).flatMapThrowing {
            guard let items = $0.items, !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }
    }
    
    func getSummaries<Summary: ItemSummary>(_ query: GetSummariesQuery) -> EventLoopFuture<[Summary]?> {
        self.query(query.dynamoDBQuery.input, type: Summary.self).flatMapThrowing {
                guard let items = $0.items, !items.isEmpty else {
                    return nil
                }
                return items
            }
    }
    
    func getSummary<Summary: ItemSummary>(_ query: GetSummaryQuery) -> EventLoopFuture<[Summary]?> {
        var futures = [EventLoopFuture<Summary?>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(getItem(input, type: Summary.self).map { $0.item })
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
