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

    let itemType: String
    let afterID: String?
    let sortValue: String?
    let limit: Int
    let table: String
    
    init(
        itemType: String,
        afterID: String?,
        sortValue: String?,
        limit: Int,
        table: String
    ) {
        self.itemType = itemType
        self.afterID = afterID
        self.sortValue = sortValue
        self.limit = limit
        self.table = table
    }

    var input: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            exclusiveStartKey: exclusiveStartKey,
            expressionAttributeValues: expressionAttributeValues,
            indexName: "itemType-sortValue-index",
            keyConditionExpression: keyConditionExpression,
            limit: limit,
            tableName: table
        )
    }
    
    private var exclusiveStartKey: [String: DynamoDB.AttributeValue]? {
        guard let afterID = afterID, let sortValue = sortValue else { return nil }
        return [
            "itemID": .s("\(itemType)#\(afterID)"),
            "itemType": .s(itemType),
            "sortValue": .s(sortValue)
        ]
    }
    
    private var expressionAttributeValues: [String: DynamoDB.AttributeValue] {
        [":itemType": .s(itemType)]
    }
    
    private var keyConditionExpression: String {
        "itemType = :itemType"
    }

    func getLogs() -> [Log] {
        [Log("GetAllItems input: \(input)")]
    }
    
}
