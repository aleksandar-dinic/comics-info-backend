//
//  DatabaseUpdate.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol DatabaseUpdate {

    func getAllSummaries(forID summaryID: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]>
    
    mutating func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void>
    
}
