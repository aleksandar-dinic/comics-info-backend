//
//  UpdateSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct UpdateSummariesQuery<Summary: ItemSummary>: LoggerProvider {
    
    let summaries: [Summary]
    let table: String
    let logger: Logger?
    
    var dynamoDBQuery: DynamoDBUpdateSummariesQuery<Summary> {
        let query = DynamoDBUpdateSummariesQuery(summaries: summaries, table: table)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    func getID(for summary: Summary) -> String {
        "\(summary.itemID)|\(summary.summaryID)"
    }
        
}
