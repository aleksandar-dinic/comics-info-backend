//
//  GetDatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class GetDatabaseProvider: ItemGetDBService {

    private var database: DatabaseGet

    public init(database: DatabaseGet) {
        self.database = database
    }

    public func getItem<Item: Codable>(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        database.getItem(withID: ID, from: table)
    }

    public func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]> {
        database.getItems(withIDs: IDs, from: table)
    }
    
    public func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]> {
        database.getAll(items, from: table)
    }
    
    public func getSummaries<Summary: ItemSummary>(
        _ summaries: String,
        forID ID: String,
        from table: String,
        by key: PartitionKey
    ) -> EventLoopFuture<[Summary]?> {
        database.getSummaries(with: GetSummariesDatabaseCriteria(itemName: summaries, ID: ID, table: table, partitionKey: key))
    }

}
