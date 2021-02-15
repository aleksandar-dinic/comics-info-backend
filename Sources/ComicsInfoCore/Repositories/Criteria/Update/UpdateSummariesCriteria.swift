//
//  UpdateSummariesCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public enum UpdateSummariesStrategy {
    
    case `default`
    case characterInSeries
    
}

public struct UpdateSummariesCriteria<Summary: ItemSummary> {
    
    let items: [Summary]
    let table: String
    let logger: Logger?
    let strategy: UpdateSummariesStrategy
    
    init(
        items: [Summary],
        table: String,
        logger: Logger? = nil,
        strategy: UpdateSummariesStrategy = .default
    ) {
        self.items = items
        self.table = table
        self.logger = logger
        self.strategy = strategy
    }
    
}
