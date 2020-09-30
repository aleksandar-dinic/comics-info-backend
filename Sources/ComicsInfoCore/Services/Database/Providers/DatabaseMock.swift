//
//  DatabaseMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct DatabaseMock: Database {

    struct Table {
        let name: String
        var items: [String: [String: Any]]

        init(name: String) {
            self.name = name
            items = [String: [String: Any]]()
        }

    }

    private let eventLoop: EventLoop
    private var tables: [String: Table]

    init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
        tables = [String: Table]()
    }

    mutating func create(_ item: [String: Any], tableName table: String) -> EventLoopFuture<Void> {
        guard let identifier = item["identifier"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.identifierDoesNotExists)
        }

        guard !tables[table, default: Table(name: table)].items.keys.contains(identifier) else {
            return eventLoop.makeFailedFuture(DatabaseError.identifierExists)
        }

        tables[table]?.items[identifier] = item
        return eventLoop.makeSucceededFuture(())
    }

    mutating func createAll(_ items: [String: [[String: Any]]]) -> EventLoopFuture<Void> {
        for (_, el) in items.enumerated() {
            for value in el.value {
                guard let identifier = value["identifier"] as? String else {
                    return eventLoop.makeFailedFuture(DatabaseError.identifierDoesNotExists)
                }

                guard !tables[el.key, default: Table(name: el.key)].items.keys.contains(identifier) else {
                    return eventLoop.makeFailedFuture(DatabaseError.identifierExists)
                }

                tables[el.key, default: Table(name: el.key)].items[identifier] = value
            }
        }

        return eventLoop.makeSucceededFuture(())
    }

    func getItem(fromTable table: String, itemID: String) -> EventLoopFuture<[[String: Any]]?> {
        eventLoop.makeSucceededFuture([
            ["identifier": "1",
             "popularity": 0,
             "name": "Name"]
        ])
    }

    func getAllItems(fromTable table: String) -> EventLoopFuture<[[String: Any]]?> {
        eventLoop.makeSucceededFuture([
            ["identifier": "1",
             "popularity": 0,
             "name": "Name"]
        ])
    }

    func getMetadata(fromTable table: String, id: String) -> EventLoopFuture<[String: Any]?> {
        eventLoop.makeSucceededFuture([
            "identifier": "1",
            "popularity": 0,
            "name": "Name"
        ])
    }

    func getAllMetadata(fromTable table: String, ids: Set<String>) -> EventLoopFuture<[[String: Any]]?> {
        eventLoop.makeSucceededFuture([[
            "identifier": "1",
            "popularity": 0,
            "name": "Name"
        ]])
    }

}
