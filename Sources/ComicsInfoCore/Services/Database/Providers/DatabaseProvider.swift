//
//  DatabaseProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class DatabaseProvider: RepositoryAPIService {

    private var database: Database

    public init(database: Database) {
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
    
    public func getSummaries<Summary: ItemSummary>(_ type: Summary.Type, forID ID: String, from table: String) -> EventLoopFuture<[Summary]?> {
        database.getSummaries(String.getType(from: type), forID: ID, from: table)
    }

}
