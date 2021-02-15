//
//  GetItemsCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetItemsCriteria {
    
    let IDs: Set<String>
    let dataSource: DataSourceLayer
    let table: String
    let logger: Logger?
    
    init(
        IDs: Set<String>,
        dataSource: DataSourceLayer,
        table: String,
        logger: Logger? = nil
    ) {
        self.IDs = IDs
        self.dataSource = dataSource
        self.table = table
        self.logger = logger
    }
    
}
