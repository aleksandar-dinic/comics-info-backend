//
//  UpdateDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class UpdateDatabaseProvider: ItemUpdateDBService {

    private var database: DatabaseUpdate

    public init(database: DatabaseUpdate) {
        self.database = database
    }
    
    public func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        database.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(
        with criteria: [UpdateSummariesCriteria<Summary>]
    ) -> EventLoopFuture<Void> {
        database.updateSummaries(with: criteria)
    }
    
}
