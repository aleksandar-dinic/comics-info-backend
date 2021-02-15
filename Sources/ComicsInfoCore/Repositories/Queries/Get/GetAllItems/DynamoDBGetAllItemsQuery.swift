//
//  DynamoDBGetAllItemsQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBGetAllItemsQuery: Loggable {

    let items: String
    let table: String

    var input: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            expressionAttributeValues: [":itemType": .s(items)],
            indexName: "itemType-summaryID-index",
            keyConditionExpression: "itemType = :itemType",
            tableName: table
        )
    }
    
    func getLogs() -> [Log] {
        [Log("GetAllItems input: \(input)")]
    }
    
}
