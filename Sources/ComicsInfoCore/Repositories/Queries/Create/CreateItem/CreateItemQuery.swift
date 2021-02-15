//
//  CreateItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct CreateItemQuery<Item: ComicInfoItem>: LoggerProvider {
    
    let item: Item
    let table: String
    let logger: Logger?
    
    var dynamoDBQuery: DynamoDBCreateItemQuery<Item> {
        let query = DynamoDBCreateItemQuery(item: item, table: table)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    var mockDBQuery: MockDBCreateItemQuery<Item> {
        let query = MockDBCreateItemQuery(item: item)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
        
}
