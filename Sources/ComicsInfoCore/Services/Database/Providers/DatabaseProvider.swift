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

    public func create(_ item: DatabaseItem) -> EventLoopFuture<Void> {
        database.create(item)
    }

    public func createAll(_ items: [DatabaseItem]) -> EventLoopFuture<Void> {
        database.createAll(items)
    }

    // Read

    public func getItem(withID itemID: String) -> EventLoopFuture<[DatabaseItem]> {
        database.getItem(withID: itemID)
    }

    public func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]> {
        database.getAll(items)
    }

    public func getMetadata(withID id: String) -> EventLoopFuture<DatabaseItem> {
        database.getMetadata(withID: id)
    }

    public func getAllMetadata(withIDs ids: Set<String>) -> EventLoopFuture<[DatabaseItem]> {
        database.getAllMetadata(withIDs: ids)
    }

//    func update(_ item: [String: Any]) -> EventLoopFuture<[String: Any]> {
//    }
//
//    func delete(forID identifier: String) -> EventLoopFuture<[String: Any]> {
//    }

}
