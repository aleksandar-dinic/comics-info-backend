//
//  DynamoDBUpdateSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBUpdateSummariesQuery<Summary: ItemSummary>: Loggable {
    
    let summaries: [Summary]
    let table: String
    let strategy: UpdateSummariesStrategy
    
    var inputs: [DynamoDB.UpdateItemCodableInput<Summary>] {
        var inputs = [DynamoDB.UpdateItemCodableInput<Summary>]()
        
        for summary in summaries {
            let update = DynamoDB.UpdateItemCodableInput(
                key: ["itemID", "summaryID"],
                tableName: table,
                updateExpression: updateExpression,
                updateItem: summary
            )
            inputs.append(update)
        }
        return inputs
    }
    
    private var updateExpression: String? {
        switch strategy {
        case .default:
            return nil
        case .characterInSeries:
            return "SET count = count + :count"
        }
    }
    
    func getLogs() -> [Log] {
        var logs = [Log("Update Summaries Query")]

        for input in inputs {
            logs.append(Log("Update Summaries input: \(input)"))
        }
        
        return logs
    }
    
}
