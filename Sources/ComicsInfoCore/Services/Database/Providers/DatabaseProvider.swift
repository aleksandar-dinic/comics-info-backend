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

    // Create

    public func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        database.create(item)
    }

    public func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
        database.createAll(items)
    }

    // Read

    public func getItem(withID itemID: String, from table: String) -> EventLoopFuture<[DatabaseItem]> {
        database.getItem(withID: itemID, tableName: table)
    }

    public func getAll(_ items: String, from table: String) -> EventLoopFuture<[DatabaseItem]> {
        database.getAll(items, tableName: table)
    }

    public func getMetadata(withID id: String, from table: String) -> EventLoopFuture<DatabaseItem> {
        database.getMetadata(withID: id, tableName: table)
    }

    public func getAllMetadata(
        withIDs ids: Set<String>,
        from table: String
    ) -> EventLoopFuture<[DatabaseItem]> {
        database.getAllMetadata(withIDs: ids, tableName: table)
    }

    public func getAllSummaries(forID summaryID: String, from table: String) -> EventLoopFuture<[DatabaseItem]> {
        database.getAllSummaries(forID: summaryID, tableName: table)
    }

    // Update

    public func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        database.update(items)
    }

//    func delete(forID identifier: String) -> EventLoopFuture<[String: Any]> {
//    }

}
