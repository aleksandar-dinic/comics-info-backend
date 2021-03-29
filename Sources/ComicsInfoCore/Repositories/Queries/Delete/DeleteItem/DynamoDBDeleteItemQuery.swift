//
//  DynamoDBDeleteItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/03/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBDeleteItemQuery: Loggable {

    let itemID: String
    let sortValue: String
    let table: String

    var input: DynamoDB.DeleteItemInput {
        DynamoDB.DeleteItemInput(
            key: ["itemID": .s(itemID), "sortValue": .s(sortValue)],
            tableName: table
        )
    }
    
    func getLogs() -> [Log] {
        [Log("DeleteItemQuery input: \(input)")]
    }
    
}
