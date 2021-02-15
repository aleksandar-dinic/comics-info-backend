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
    
    func create<Item: Codable>(_ query: CreateItemQuery<Item>) -> EventLoopFuture<Void> {
        putItem(query.dynamoDBQuery.input).map { _ in }
    }

    func createSummaries<Summary: Codable>(_ query: CreateSummariesQuery<Summary>) -> EventLoopFuture<Void> {
        var futures = [EventLoopFuture<Void>]()
        
        for input in query.dynamoDBQuery.inputs {
            futures.append(putItem(input).map { _ in })
        }

        return EventLoopFuture.reduce((), futures, on: client.eventLoopGroup.next()) { (_, _) in }
    }

}
