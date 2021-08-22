//
//  GetSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetSummariesQuery<Summary: ItemSummary>: LoggerProvider {
    
    let itemType: String
    let ID: String
    let afterID: String?
    let sortValue: String?
    let limit: Int
    let table: String
    let strategy: GetSummariesStrategy
    let logger: Logger?
    
    var initialValue: [Summary]
    
    var dynamoDBQuery: DynamoDBGetSummariesQuery {
        let query = DynamoDBGetSummariesQuery(
            itemType: itemType,
            ID: ID,
            afterID: getAfterID(),
            sortValue: getSortValue(),
            limit: getLimit(),
            table: table,
            strategy: strategy
        )
        
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
    
    private func getAfterID() -> String? {
        guard let last = initialValue.last else {
            return afterID
        }
        return last.itemID.getIDFromComicInfoID(for: Summary.self)
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
