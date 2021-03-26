//
//  GetAllItemsQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetAllItemsQuery<Item: ComicInfoItem>: LoggerProvider {
    
    let items: String
    let afterID: String?
    let sortValue: String?
    let limit: Int
    let table: String
    let logger: Logger?
    
    var initialValue: [Item]
    
    var dynamoDBQuery: DynamoDBGetAllItemsQuery {
        let query = DynamoDBGetAllItemsQuery(
            itemType: items,
            afterID: getAfterID(),
            sortValue: getSortValue(),
            limit: getLimit(),
            table: table
        )
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    private func getAfterID() -> String? {
        guard let last = initialValue.last else {
            return afterID
        }
        return last.id
    }
    
    private func getSortValue() -> String? {
        guard let last = initialValue.last else {
            return sortValue
        }
        return last.sortValue
    }
    
    private func getLimit() -> Int {
        limit - initialValue.count
    }
            
}
