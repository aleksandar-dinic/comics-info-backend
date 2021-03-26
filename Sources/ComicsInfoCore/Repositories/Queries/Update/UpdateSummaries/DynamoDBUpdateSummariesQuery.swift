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
    
    var inputs: [(DynamoDB.DeleteItemInput, DynamoDB.UpdateItemCodableInput<Summary>)] {
        var inputs = [(DynamoDB.DeleteItemInput, DynamoDB.UpdateItemCodableInput<Summary>)]()
        
        for summary in summaries {
            let delete = DynamoDB.DeleteItemInput(
                key: ["itemID": .s(summary.itemID), "sortValue": .s(summary.oldSortValue ?? summary.sortValue)],
                tableName: table
            )
            let update = DynamoDB.UpdateItemCodableInput(
                key: ["itemID", "sortValue"],
                tableName: table,
                updateItem: summary
            )
            inputs.append((delete, update))
        }
        return inputs
    }
    
    func getLogs() -> [Log] {
        var logs = [Log("Update Summaries Query")]

        for input in inputs {
            logs.append(Log("Update Summaries input: \(input)"))
        }
        
        return logs
    }
    
}
