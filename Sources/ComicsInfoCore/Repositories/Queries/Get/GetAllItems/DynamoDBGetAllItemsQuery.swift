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
    let summaryID: String?
    let table: String
    
    init(
        itemType: String,
        summaryID: String? = nil,
        table: String
    ) {
        self.itemType = itemType
        self.summaryID = summaryID
        self.table = table
    }

    var input: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            expressionAttributeValues: expressionAttributeValues,
            indexName: "itemType-summaryID-index",
            keyConditionExpression: keyConditionExpression,
            tableName: table
        )
    }
    
    private var expressionAttributeValues: [String: DynamoDB.AttributeValue] {
        var attributeValues: [String: DynamoDB.AttributeValue] = [":itemType": .s(itemType)]
        guard let summaryID = summaryID else {
            return attributeValues
        }
        
        attributeValues[":summaryID"] = .s(summaryID)
        return attributeValues
    }
    
    private var keyConditionExpression: String {
        let keyCondition = "itemType = :itemType"
        guard summaryID != nil else {
            return keyCondition
        }
        
        return "\(keyCondition) AND summaryID = :summaryID"
    }

    func getLogs() -> [Log] {
        [Log("GetAllItems input: \(input)")]
    }
    
}
