//
//  UpdateSummariesCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct UpdateSummariesCriteria<Summary: ItemSummary> {
    
    let items: [Summary]
    let table: String
    let logger: Logger?
    
    init(
        items: [Summary],
        table: String,
        logger: Logger? = nil
    ) {
        self.items = items
        self.table = table
        self.logger = logger
    }
    
}
