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

    private let eventLoop: EventLoop
    private var items: [String: [String: Any]]

    init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
        items = [String: [String: Any]]()
    }

    mutating func create(_ item: [String: Any], tableName table: String) -> EventLoopFuture<Void> {
        guard let identifier = item["identifier"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.identifierDoesNotExists)
        }
        guard !items.keys.contains(identifier) else {
            return eventLoop.makeFailedFuture(DatabaseError.identifierExists)
        }

        items[identifier] = item
        return eventLoop.makeSucceededFuture(())
    }

    func getAll(fromTable table: String) -> EventLoopFuture<[[String : Any]]?> {
        eventLoop.makeSucceededFuture([
            ["identifier": "1",
             "popularity": 0,
             "name": "Name"]
        ])
    }

    func get<ID: Hashable>(fromTable table: String, forID identifier: ID) -> EventLoopFuture<[String : Any]?> {
        eventLoop.makeSucceededFuture([
            "identifier": "1",
            "popularity": 0,
            "name": "Name"
        ])
    }

}
