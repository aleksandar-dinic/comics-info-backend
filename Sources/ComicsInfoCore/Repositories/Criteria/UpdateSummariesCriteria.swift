//
//  UpdateSummariesCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import SotoDynamoDB
import Foundation

public enum UpdateSummariesStrategy {
    
    case `default`
    case characterInSeries
    
}

public struct UpdateSummariesCriteria<Summary: ItemSummary> {
    
    private let key: [String]
    private let table: String
    let item: Summary
    let strategy: UpdateSummariesStrategy
    
    init(
        key: [String] = ["itemID", "summaryID"],
        table: String,
        item: Summary,
        strategy: UpdateSummariesStrategy = .default
    ) {
        self.key = key
        self.table = table
        self.item = item
        self.strategy = strategy
    }
    
}

extension UpdateSummariesCriteria {
    
    var updateInput: DynamoDB.UpdateItemCodableInput<Summary> {
        DynamoDB.UpdateItemCodableInput(
            key: key,
            tableName: table,
            updateExpression: updateExpression,
            updateItem: item
        )
    }
    
    private var updateExpression: String? {
        switch strategy {
        case .default:
            return nil
        case .characterInSeries:
            return "SET count = count + :count"
        }
    }
    
}

extension UpdateSummariesCriteria {
    
    var ID: String {
        "\(item.itemID)|\(item.summaryID)"
    }
    
    func getData(oldData: Data?) -> Data? {
        guard strategy != .default else {
            return try? JSONEncoder().encode(item)
        }
        
        guard strategy == .characterInSeries,
              let newSummary = item as? CharacterSummary,
              let oldData = oldData,
              let oldSummary = try? JSONDecoder().decode(CharacterSummary.self, from: oldData) else {
            return try? JSONEncoder().encode(item)
        }
        
        let updatedSummary = CharacterSummary(
            itemID: newSummary.itemID,
            summaryID: newSummary.summaryID,
            itemName: newSummary.itemName,
            dateAdded: newSummary.dateAdded,
            dateLastUpdated: newSummary.dateLastUpdated,
            popularity: newSummary.popularity,
            name: newSummary.name,
            thumbnail: newSummary.thumbnail,
            description: newSummary.description,
            count: (newSummary.count ?? 0) + (oldSummary.count ?? 0)
        )
        
        guard let itemData = try? JSONEncoder().encode(updatedSummary) else { return nil }
        return itemData
    }
}
