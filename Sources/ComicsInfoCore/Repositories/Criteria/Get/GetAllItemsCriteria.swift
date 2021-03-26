//
//  GetAllItemsCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetAllItemsCriteria<Item: ComicInfoItem> {
    
    let afterID: String?
    var sortValue: String?
    let dataSource: DataSourceLayer
    let limit: Int
    let table: String
    var initialValue: [Item]
    let logger: Logger?
    
    init(
        afterID: String?,
        sortValue: String?,
        dataSource: DataSourceLayer,
        limit: Int,
        table: String,
        initialValue: [Item] = [],
        logger: Logger? = nil
    ) {
        self.afterID = afterID
        self.sortValue = sortValue
        self.dataSource = dataSource
        self.limit = limit
        self.table = table
        self.initialValue = initialValue
        self.logger = logger
    }
    
}
