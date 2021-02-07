//
//  GetItemsCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct GetItemsCriteria {
    
    let IDs: Set<String>
    let dataSource: DataSourceLayer
    let table: String
    
}
