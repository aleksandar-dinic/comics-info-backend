//
//  GetSummariesCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public enum GetSummariesStrategy {
    case itemID
    case summaryID
}

public struct GetSummariesCriteria<Summary: ItemSummary> {
    
    let itemType: String
    let ID: String
    let limit: Int
    let dataSource: DataSourceLayer
    let table: String
    let strategy: GetSummariesStrategy
    let logger: Logger?
    
    init(
        _ summaryType: Summary.Type,
        ID: String,
        dataSource: DataSourceLayer,
        limit: Int,
        table: String,
        strategy: GetSummariesStrategy,
        logger: Logger? = nil
    ) {
        itemType = .getType(from: Summary.self)
        self.ID = .comicInfoID(for: Summary.self, ID: ID)
        self.dataSource = dataSource
        self.limit = limit
        self.table = table
        self.strategy = strategy
        self.logger = logger
    }
    
    init(
        _ summaryType: Summary.Type,
        summaryID: String,
        dataSource: DataSourceLayer,
        limit: Int,
        table: String,
        strategy: GetSummariesStrategy,
        logger: Logger? = nil
    ) {
        itemType = .getType(from: Summary.self)
        ID = summaryID
        self.dataSource = dataSource
        self.limit = limit
        self.table = table
        self.strategy = strategy
        self.logger = logger
    }
    
}
