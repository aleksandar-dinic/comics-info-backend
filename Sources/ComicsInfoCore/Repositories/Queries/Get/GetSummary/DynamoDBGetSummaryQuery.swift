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

    var inputs: [DynamoDB.QueryInput] {
        var inputs = [DynamoDB.QueryInput]()
        for item in items {
            let get = DynamoDB.QueryInput(
                expressionAttributeValues: [":summaryID": .s(item.summaryID), ":itemID": .s(item.itemID)],
                indexName: "summaryID-itemID-index",
                keyConditionExpression: "summaryID = :summaryID AND itemID = :itemID",
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
