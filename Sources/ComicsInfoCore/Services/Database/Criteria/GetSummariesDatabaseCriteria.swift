//
//  GetSummariesDatabaseCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/02/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation

public struct GetSummariesDatabaseCriteria {
    
    let itemName: String
    let ID: String
    let table: String
    let partitionKey: PartitionKey
    
}

extension GetSummariesDatabaseCriteria {
    
    func isValidKey(_ key: String) -> Bool {
        switch partitionKey {
        case .itemID:
            return key.hasPrefix(ID)
        case .summaryID:
            return key.hasSuffix(ID)
        }
    }
    
}

extension GetSummariesDatabaseCriteria {
    
    var queryInput: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            expressionAttributeValues: expressionAttributeValues,
            indexName: indexName,
            keyConditionExpression: keyConditionExpression,
            tableName: table
        )
    }
    
    private var expressionAttributeValues: [String: DynamoDB.AttributeValue] {
        switch partitionKey {
        case .itemID:
            return [":itemName": .s(itemName), ":itemID": .s(ID)]
        case .summaryID:
            return [":itemName": .s(itemName), ":summaryID": .s(ID)]
        }
    }
    
    private var indexName: String {
        switch partitionKey {
        case .itemID:
            return "itemName-itemID-index"
        case .summaryID:
            return "itemName-summaryID-index"
        }
    }
    
    private var keyConditionExpression: String {
        switch partitionKey {
        case .itemID:
            return "itemName = :itemName AND itemID = :itemID"
        case .summaryID:
            return "itemName = :itemName AND summaryID = :summaryID"
        }
    }
    
}
