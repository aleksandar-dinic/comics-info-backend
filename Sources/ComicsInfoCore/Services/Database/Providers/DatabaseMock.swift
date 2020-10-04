//
//  DatabaseMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

struct DatabaseMock: Database {

    struct Table {
        let name: String
        var items: [String: DatabaseItem]

        init(name: String) {
            self.name = name
            items = [String: DatabaseItem]()
        }

    }

    private let eventLoop: EventLoop
    private let tableName: String
    private let logger: Logger
    private var tables: [String: Table]

    init(eventLoop: EventLoop, tableName: String, logger: Logger) {
        self.eventLoop = eventLoop
        self.tableName = tableName
        self.logger = logger
        tables = [String: Table]()
    }

    mutating func create(_ item: DatabaseItem) -> EventLoopFuture<Void> {
        logger.log(level: .info, "item: \(item))")

        guard let id = item["id"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveID)
        }

        guard !tables[item.table, default: Table(name: item.table)].items.keys.contains(id) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
        }

        tables[item.table]?.items[id] = item
        return eventLoop.makeSucceededFuture(())
    }

    mutating func createAll(_ items: [DatabaseItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "items: \(items))")

        for item in items {
            guard let id = item["id"] as? String else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveID)
            }

            guard !tables[item.table, default: Table(name: item.table)].items.keys.contains(id) else {
                return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
            }

            tables[item.table, default: Table(name: item.table)].items[id] = item
        }

        return eventLoop.makeSucceededFuture(())
    }

    func getItem(withID itemID: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "withID: \(itemID))")

        let items = [
            DatabaseItem(["identifier": "1", "popularity": 0, "name": "Name"], table: tableName)
        ]
        return eventLoop.makeSucceededFuture(items)
    }

    func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "items: \(items))")

        let items = [
            DatabaseItem(["identifier": "1", "popularity": 0, "name": "Name"], table: tableName)
        ]
        return eventLoop.makeSucceededFuture(items)
    }

    func getMetadata(withID id: String) -> EventLoopFuture<DatabaseItem> {
        logger.log(level: .info, "withID: \(id))")

        let item = DatabaseItem(["identifier": "1", "popularity": 0, "name": "Name"], table: tableName)
        return eventLoop.makeSucceededFuture(item)
    }

    func getAllMetadata(withIDs ids: Set<String>) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "withIDs: \(ids))")

        let items = [
            DatabaseItem(["identifier": "1", "popularity": 0, "name": "Name"], table: tableName)
        ]
        return eventLoop.makeSucceededFuture(items)
    }

}
