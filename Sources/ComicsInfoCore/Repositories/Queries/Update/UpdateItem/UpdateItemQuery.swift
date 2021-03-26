//
//  UpdateItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct UpdateItemQuery<Item: ComicInfoItem>: LoggerProvider {
    
    let item: Item
    let oldSortValue: String
    let table: String
    let logger: Logger?
    
    var id: String {
        item.itemID
    }
    
    var dynamoDBQuery: DynamoDBUpdateItemQuery<Item> {
        let query = DynamoDBUpdateItemQuery(item: item, oldSortValue: oldSortValue, table: table)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
            
}
