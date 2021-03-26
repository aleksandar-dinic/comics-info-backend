//
//  DynamoDBGetItemsQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBGetItemsQuery: Loggable {

    let IDs: Set<String>
    let table: String

    var inputs: [(id: String, input: DynamoDB.QueryInput)] {
        var inputs = [(String, DynamoDB.QueryInput)]()
        for id in IDs {
            let input = DynamoDB.QueryInput(
                expressionAttributeValues: [":itemID": .s(id)],
                indexName: "itemID-index",
                keyConditionExpression: "itemID = :itemID",
                tableName: table
            )
            inputs.append((id, input))
        }
        return inputs
    }
    
    func getLogs() -> [Log] {
        var logs = [Log("GetItems Query")]

        for input in inputs {
            logs.append(Log("GetItems input: \(input)"))
        }
        
        return logs
    }
    
}
