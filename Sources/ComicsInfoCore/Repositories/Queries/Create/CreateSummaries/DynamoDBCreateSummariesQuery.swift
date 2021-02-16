//
//  DynamoDBCreateSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBCreateSummariesQuery<Summary: ItemSummary>: Loggable {
    
    let summaries: [Summary]
    let table: String
    
    var inputs: [DynamoDB.PutItemCodableInput<Summary>] {
        var inputs = [DynamoDB.PutItemCodableInput<Summary>]()
        for summary in summaries {
            let put = DynamoDB.PutItemCodableInput(
                item: summary,
                tableName: table
            )
            inputs.append(put)
        }
        return inputs
    }
    
    func getLogs() -> [Log] {
        var logs = [Log("Create Summaries Query")]

        for input in inputs {
            logs.append(Log("Create Summaries input: \(input)"))
        }
        
        return logs
    }
    
}
