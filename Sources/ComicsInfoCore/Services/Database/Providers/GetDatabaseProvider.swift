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
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        database.getSummaries(with: criteria)
    }
    
    public func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        database.getSummary(with: criteria)
    }

}
