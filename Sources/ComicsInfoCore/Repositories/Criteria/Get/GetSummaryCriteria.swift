//
//  GetSummaryCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation

public struct GetSummaryCriteria {
    
    let items: [(itemID: String, summaryID: String)]
    let table: String
    let logger: Logger?
    
}
