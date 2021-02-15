//
//  DynamoDBGetItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBGetItemQuery: Loggable {

    let ID: String
    let table: String

    var input: DynamoDB.GetItemInput {
        DynamoDB.GetItemInput(
            key: ["itemID": .s(ID), "summaryID": .s(ID)],
            tableName: table
        )
    }
    
    func getLogs() -> [Log] {
        [Log("GetItem input: \(input)")]
    }
    
}
