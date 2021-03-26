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
    let oldSortValue: String
    let table: String

    var input: DynamoDB.UpdateItemCodableInput<Item> {
        DynamoDB.UpdateItemCodableInput(
            key: ["itemID", "sortValue"],
            returnValues: .updatedOld,
            tableName: table,
            updateItem: item
        )
    }
    
    var deleteInput: DynamoDB.DeleteItemInput {
        DynamoDB.DeleteItemInput(
            key: ["itemID": .s(item.itemID), "sortValue": .s(oldSortValue)],
            tableName: table
        )
    }
    
    func getLogs() -> [Log] {
        [Log("UpdateItemQuery input: \(input)")]
    }
    
}
