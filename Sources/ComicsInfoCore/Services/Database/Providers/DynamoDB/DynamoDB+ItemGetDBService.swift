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
        return self.query(query.dynamoDBQuery.input, type: Item.self).flatMapThrowing {
            guard let item = $0.items?.first else {
                throw DatabaseError.itemNotFound(withID: query.dynamoDBQuery.ID)
            }
            return item
        }.flatMapErrorThrowing {
            print("GetItem ERROR: \($0)")
            throw $0
        }
    }
    
    func getItems<Item: ComicInfoItem>(_ query: GetItemsQuery) -> EventLoopFuture<[Item]> {
        var futures = [EventLoopFuture<Item>]()
        
        for (id, input) in query.dynamoDBQuery.inputs {
            let future: EventLoopFuture<Item> = self.query(input, type: Item.self)
                .flatMapThrowing {
                    guard let item = $0.items?.first else {
                        throw DatabaseError.itemNotFound(withID: id)
                    }
                    return item
                }
                .flatMapErrorThrowing {
                    print("GetItems ERROR: \($0)")
                    throw $0
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
        }.flatMapErrorThrowing {
            print("GetItems ERROR: \($0)")
            throw $0
        }
    }

    func getAll<Item: ComicInfoItem>(_ query: GetAllItemsQuery<Item>) -> EventLoopFuture<[Item]> {
        queryPaginator(query.dynamoDBQuery.input, query.initialValue, type: Item.self) { (result, output, eventLoop) -> EventLoopFuture<(Bool, [Item])> in
            guard let items = output.items, !items.isEmpty else {
                return eventLoop.submit { (false, result) }
            }
            return eventLoop.submit { (false, result + items) }
        }.flatMapThrowing { items in
            guard !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }.flatMapErrorThrowing {
            print("GetAll ERROR: \($0)")
            throw $0
        }
    }
    
    func getSummaries<Summary: ItemSummary>(_ query: GetSummariesQuery<Summary>) -> EventLoopFuture<[Summary]?> {
        return queryPaginator(query.dynamoDBQuery.input, query.initialValue, type: Summary.self) { (result, output, eventLoop) -> EventLoopFuture<(Bool, [Summary])> in
            print("RESULT: \(result)")
            print("OUTPUT: \(output)")
            guard let items = output.items, !items.isEmpty else {
                return eventLoop.submit { (false, result) }
            }
            return eventLoop.submit { (false, result + items) }
        }.flatMapThrowing { items in
            print("ITEMS: \(items)")
            guard !items.isEmpty else {
                throw DatabaseError.itemsNotFound(withIDs: nil)
            }
            return items
        }.flatMapErrorThrowing {
            print("GetSummaries ERROR: \($0)")
            throw $0
        }
    }
    
    func getSummary<Summary: ItemSummary>(_ query: GetSummaryQuery) -> EventLoopFuture<[Summary]?> {
        var futures = [EventLoopFuture<Summary?>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(
                self.query(input, type: Summary.self)
                    .map { $0.items?.first }
                    .flatMapErrorThrowing {
                        print("GetSummary ERROR: \($0)")
                        throw $0
                    }
            )
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
