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
    let strategy: UpdateSummariesStrategy
    
    var dynamoDBQuery: DynamoDBUpdateSummariesQuery<Summary> {
        let query = DynamoDBUpdateSummariesQuery(summaries: summaries, table: table, strategy: strategy)
        
        guard let logger = logger else {
            return query
        }
        return log(logger, loggable: query)
    }
    
    func getID(for summary: Summary) -> String {
        "\(summary.itemID)|\(summary.summaryID)"
    }
    
    func getData(for summary: Summary, oldData: Data?) -> Data? {
        guard strategy != .default else {
            return try? JSONEncoder().encode(summary)
        }
        
        guard strategy == .characterInSeries,
              var newSummary = summary as? CharacterSummary,
              let oldData = oldData,
              let oldSummary = try? JSONDecoder().decode(CharacterSummary.self, from: oldData) else {
            return try? JSONEncoder().encode(summary)
        }

        newSummary.incrementCount(oldSummary.count ?? 0)
        
        guard let itemData = try? JSONEncoder().encode(newSummary) else { return nil }
        return itemData
    }
    
}
