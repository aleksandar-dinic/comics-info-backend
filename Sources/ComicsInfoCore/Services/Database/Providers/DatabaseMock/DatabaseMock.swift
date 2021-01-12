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

    static var tables = [String: TableMock]()

    static func removeAll() {
        DatabaseMock.tables.removeAll()
    }

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger, tables: [String: TableMock]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in tables.enumerated() {
            for item in el.value.items {
                DatabaseMock.tables[el.key, default: TableMock(name: el.key)].items[item.key] = item.value
            }
        }
    }

    func getItem(withID itemID: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetItem withID: \(itemID))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: itemID))
        }

        return eventLoop.makeSucceededFuture(items.filter({ $0.attributes["itemID"] as? String == itemID }))
    }

    func getAll(_ items: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetAll items: \(items))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.makeSucceededFuture(items)
    }

    func getMetadata(withID id: String, tableName: String) -> EventLoopFuture<DatabaseItem> {
        logger.log(level: .info, "GetMetadata withID: \(id))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard let item = items.first(where: { $0.attributes["itemID"] as? String == id }) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
        }

        return eventLoop.makeSucceededFuture(item)
    }

    func getAllMetadata(withIDs ids: Set<String>, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetAllMetadata withIDs: \(ids))")

        var items = [DatabaseItem]()
        for id in ids {
            guard let item = DatabaseMock.tables[tableName]?.items["\(id)|\(id)"] else { continue }
            items.append(item)
        }

        return eventLoop.makeSucceededFuture(items)
    }

}
