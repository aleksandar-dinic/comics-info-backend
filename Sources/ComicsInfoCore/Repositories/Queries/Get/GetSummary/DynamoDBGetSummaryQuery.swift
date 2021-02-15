//
//  DynamoDBGetSummaryQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBGetSummaryQuery: Loggable {

    let items: [(itemID: String, summaryID: String)]
    let table: String

    var inputs: [DynamoDB.GetItemInput] {
        var inputs = [DynamoDB.GetItemInput]()
        for item in items {
            let get = DynamoDB.GetItemInput(
                key: ["itemID": .s(item.itemID), "summaryID": .s(item.summaryID)],
                tableName: table
            )
            inputs.append(get)
        }
        return inputs
    }
    
    func getLogs() -> [Log] {
        var logs = [Log("GetSummary Query")]

        for input in inputs {
            logs.append(Log("GetSummary input: \(input)"))
        }
        
        return logs
    }
    
}
