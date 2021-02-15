//
//  DynamoDBUpdateItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBUpdateItemQuery<Item: ComicInfoItem>: Loggable {

    let item: Item
    let table: String

    var input: DynamoDB.UpdateItemCodableInput<Item> {
        DynamoDB.UpdateItemCodableInput(
            conditionExpression: "attribute_exists(itemID) AND attribute_exists(summaryID)",
            key: ["itemID", "summaryID"],
            returnValues: .updatedOld,
            tableName: table,
            updateItem: item
        )
    }
    
    func getLogs() -> [Log] {
        [Log("UpdateItemQuery input: \(input)")]
    }
    
}
