//
//  DynamoDBGetSummariesQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 15/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import SotoDynamoDB

struct DynamoDBGetSummariesQuery: Loggable {

    let itemType: String
    let ID: String
    let limit: Int
    let table: String
    let strategy: GetSummariesStrategy

    var input: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            exclusiveStartKey: exclusiveStartKey,
            expressionAttributeValues: expressionAttributeValues,
            indexName: indexName,
            keyConditionExpression: keyConditionExpression,
            limit: limit,
            tableName: table
        )
    }
    
    private var exclusiveStartKey: [String: DynamoDB.AttributeValue]? {
        nil
    }
    
    private var expressionAttributeValues: [String: DynamoDB.AttributeValue] {
        switch strategy {
        case .itemID:
            return [":itemType": .s(itemType), ":itemID": .s(ID)]
        case .summaryID:
            return [":itemType": .s(itemType), ":summaryID": .s(ID)]
        }
    }
    
    private var indexName: String {
        switch strategy {
        case .itemID:
            return "itemType-itemID-index"
        case .summaryID:
            return "itemType-summaryID-index"
        }
    }
    
    private var keyConditionExpression: String {
        switch strategy {
        case .itemID:
            return "itemType = :itemType AND itemID = :itemID"
        case .summaryID:
            return "itemType = :itemType AND summaryID = :summaryID"
        }
    }
    
    func getLogs() -> [Log] {
        [Log("GetSummaries Query: \(input)")]
    }
    
}
