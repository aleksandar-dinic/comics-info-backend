//
//  DynamoDB+ItemCreateDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

extension DynamoDB: ItemCreateDBService {
    
    func create<Item: Codable>(_ query: CreateItemQuery<Item>) -> EventLoopFuture<Item> {
        putItem(query.dynamoDBQuery.input)
            .map { _ in query.item }
            .flatMapErrorThrowing {
                print("Create ERROR: \($0)")
                throw $0
            }
    }

    func createSummaries<Summary: Codable>(
        _ query: CreateSummariesQuery<Summary>
    ) -> EventLoopFuture<[Summary]> {
        var futures = [EventLoopFuture<Summary>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(
                putItem(input)
                    .map { _ in input.item }
                    .flatMapErrorThrowing {
                        print("CreateSummaries ERROR: \($0)")
                        throw $0
                    }
            )
        }

        return EventLoopFuture.reduce([], futures, on: client.eventLoopGroup.next()) { (items, item) in
            var items = items
            items.append(item)
            return items
        }
    }

}
