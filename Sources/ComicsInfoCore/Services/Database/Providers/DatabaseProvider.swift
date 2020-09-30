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
    private let tableName: String

    public init(database: Database, tableName: String) {
        self.database = database
        self.tableName = tableName
    }

    // Create

    public func create(_ item: [String: Any]) -> EventLoopFuture<Void> {
        database.create(item, tableName: tableName)
    }

    public func createAll(_ items: [String: [[String: Any]]]) -> EventLoopFuture<Void> {
        database.createAll(items)
    }

    // Read

    public func getItem(withID itemID: String) -> EventLoopFuture<[[String: Any]]?> {
        database.getItem(fromTable: tableName, itemID: itemID)
    }

    public func getAllItems() -> EventLoopFuture<[[String: Any]]?> {
        database.getAllItems(fromTable: tableName)
    }

    public func getMetadata(id: String) -> EventLoopFuture<[String: Any]?> {
        database.getMetadata(fromTable: tableName, id: id)
    }

    public func getAllMetadata(ids: Set<String>) -> EventLoopFuture<[[String: Any]]?> {
        database.getAllMetadata(fromTable: tableName, ids: ids)
    }

//    func update(_ item: [String: Any]) -> EventLoopFuture<[String: Any]> {
//    }
//
//    func delete(forID identifier: String) -> EventLoopFuture<[String: Any]> {
//    }

}
