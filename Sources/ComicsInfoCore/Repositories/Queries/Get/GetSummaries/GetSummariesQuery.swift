//
//  GetSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetSummariesQuery: LoggerProvider {
    
    let itemType: String
    let ID: String
    let limit: Int
    let table: String
    let strategy: GetSummariesStrategy
    let logger: Logger?
    
    var dynamoDBQuery: DynamoDBGetSummariesQuery {
        let query = DynamoDBGetSummariesQuery(itemType: itemType, ID: ID, limit: limit, table: table, strategy: strategy)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    func isValidKey(_ key: String) -> Bool {
        switch strategy {
        case .itemID:
            return key.hasPrefix(ID)
        case .summaryID:
            return key.hasSuffix(ID)
        }
    }
            
}
