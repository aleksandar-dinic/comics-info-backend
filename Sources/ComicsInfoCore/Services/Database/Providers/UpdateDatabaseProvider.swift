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
    
    public func update<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Set<String>> {
        database.update(item, in: table)
    }
    
    public func updateSummaries<Summary: ItemSummary>(_ items: [Summary], in table: String) -> EventLoopFuture<Void> {
        database.updateSummaries(items, in: table)
    }
    
}
