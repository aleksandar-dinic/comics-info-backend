//
//  DeleteItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct DeleteItemQuery<Item: ComicInfoItem>: LoggerProvider {
    
    let item: Item
    let table: String
    let logger: Logger?
    
    var dynamoDBQuery: DynamoDBDeleteItemQuery {
        let query = DynamoDBDeleteItemQuery(itemID: item.itemID, sortValue: item.sortValue, table: table)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    var id: String {
        item.itemID
    }
            
}
