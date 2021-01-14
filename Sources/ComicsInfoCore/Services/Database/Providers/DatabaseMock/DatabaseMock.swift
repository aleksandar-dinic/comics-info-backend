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

    static var items = [String: TableMock]()

    static func removeAll() {
        DatabaseMock.items.removeAll()
    }

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger, items: [String: TableMock]) {
        self.eventLoop = eventLoop
        self.logger = logger
        
        for (_, el) in items.enumerated() {
            DatabaseMock.items[el.key] = el.value
        }
    }

    func getItem(withID itemID: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]> {
        logger.log(level: .info, "GetItem withID: \(itemID))")

        var items = [DatabaseGetItem]()
        for value in DatabaseMock.items.values {
            guard value.getItemID() == itemID else { continue }
            items.append(DatabaseGetItem(value.attributesValue, table: tableName))
        }

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: itemID))
        }

        return eventLoop.makeSucceededFuture(items)
    }

    func getAll(_ items: String, tableName: String) -> EventLoopFuture<[DatabaseGetItem]> {
        logger.log(level: .info, "GetAll items: \(items))")

        var items = [DatabaseGetItem]()
        for value in DatabaseMock.items.values {
            items.append(DatabaseGetItem(value.attributesValue, table: tableName))
        }

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.makeSucceededFuture(items)
    }

    func getMetadata(withID id: String, tableName: String) -> EventLoopFuture<DatabaseGetItem> {
        logger.log(level: .info, "GetMetadata withID: \(id))")

        var items = [DatabaseGetItem]()
        for key in DatabaseMock.items.keys where key.hasPrefix(id) {
            guard let item = DatabaseMock.items[key] else { continue }
            items.append(DatabaseGetItem(item.attributesValue, table: tableName))
        }

        guard let item = items.first else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
        }

        return eventLoop.makeSucceededFuture(item)
    }

    func getAllMetadata(withIDs ids: Set<String>, tableName: String) -> EventLoopFuture<[DatabaseGetItem]> {
        logger.log(level: .info, "GetAllMetadata withIDs: \(ids))")

        var items = [DatabaseGetItem]()
        for id in ids {
            guard let item = DatabaseMock.items["\(id)|\(id)"] else { continue }
            items.append(DatabaseGetItem(item.attributesValue, table: tableName))
        }

        return eventLoop.makeSucceededFuture(items)
    }

}
