//
//  UpdateDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class UpdateDatabaseProvider: UpdateRepositoryAPIService {

    private var database: DatabaseUpdate

    public init(database: DatabaseUpdate) {
        self.database = database
    }
    
    public func getAllSummaries(forID summaryID: String, from table: String) -> EventLoopFuture<[DatabaseGetItem]> {
        database.getAllSummaries(forID: summaryID, tableName: table)
    }

    public func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        database.update(items)
    }

}
