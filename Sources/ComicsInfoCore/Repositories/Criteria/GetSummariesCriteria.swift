//
//  GetSummariesCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation

public enum GetSummariesStrategy {
    case itemID
    case summaryID
}

public struct GetSummariesCriteria<Summary: ItemSummary> {
    
    let itemType: String
    let ID: String
    let dataSource: DataSourceLayer
    let table: String
    let strategy: GetSummariesStrategy
    
    init(
        _ summaryType: Summary.Type,
        ID: String,
        dataSource: DataSourceLayer,
        table: String,
        strategy: GetSummariesStrategy
    ) {
        itemType = .getType(from: Summary.self)
        self.ID = ID
        self.dataSource = dataSource
        self.table = table
        self.strategy = strategy
    }
    
}

extension GetSummariesCriteria {
    
    func isValidKey(_ key: String) -> Bool {
        switch strategy {
        case .itemID:
            return key.hasPrefix(ID)
        case .summaryID:
            return key.hasSuffix(ID)
        }
    }
    
}

extension GetSummariesCriteria {
    
    var queryInput: DynamoDB.QueryInput {
        DynamoDB.QueryInput(
            expressionAttributeValues: expressionAttributeValues,
            indexName: indexName,
            keyConditionExpression: keyConditionExpression,
            tableName: table
        )
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
    
}
