//
//  CreateDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CreateDatabaseProvider: ItemCreateDBService {

    private var database: DatabaseCreate

    public init(database: DatabaseCreate) {
        self.database = database
    }
    
    public func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        database.create(item, in: table)
    }
    
    public func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        database.createSummaries(summaries, in: table)
    }
    
}
