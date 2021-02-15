//
//  GetSummaryQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetSummaryQuery: LoggerProvider {
    
    let items: [(itemID: String, summaryID: String)]
    let table: String
    let logger: Logger?
    
    var dynamoDBQuery: DynamoDBGetSummaryQuery {
        let query = DynamoDBGetSummaryQuery(items: items, table: table)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
            
}
