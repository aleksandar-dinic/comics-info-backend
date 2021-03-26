//
//  DynamoDBCreateItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBCreateItemQuery<Item: ComicInfoItem>: Loggable {

    let item: Item
    let table: String

    var input: DynamoDB.PutItemCodableInput<Item> {
        DynamoDB.PutItemCodableInput(
            conditionExpression: "attribute_not_exists(itemID)",
            item: item,
            tableName: table
        )
    }
    
    func getLogs() -> [Log] {
        [Log("CreateItemQuery input: \(input)")]
    }
    
}
