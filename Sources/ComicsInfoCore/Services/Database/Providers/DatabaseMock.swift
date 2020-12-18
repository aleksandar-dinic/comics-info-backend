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

    private static var tables = [String: Table]()

    static func removeAll() {
        DatabaseMock.tables.removeAll()
    }

    struct Table {
        let name: String
        var items: [String: DatabaseItem]

        init(name: String) {
            self.name = name
            items = [String: DatabaseItem]()
        }

    }

    private let eventLoop: EventLoop
    private let logger: Logger

    init(eventLoop: EventLoop, logger: Logger) {
        self.eventLoop = eventLoop
        self.logger = logger
    }

    mutating func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Create item: \(item))")

        guard let itemID = item["itemID"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
        }

        guard let summaryID = item["summaryID"] as? String else {
            return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
        }

        let id = "\(itemID)|\(summaryID)"
        guard !DatabaseMock.tables[item.table, default: Table(name: item.table)].items.keys.contains(id) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
        }

        DatabaseMock.tables[item.table, default: Table(name: item.table)].items[id] = item
        return eventLoop.makeSucceededFuture(())
    }

    mutating func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "CreateAll items: \(items))")

        for item in items {
            guard let itemID = item["itemID"] as? String else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
            }

            guard let summaryID = item["summaryID"] as? String else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
            }

            let id = "\(itemID)|\(summaryID)"
            guard !DatabaseMock.tables[item.table, default: Table(name: item.table)].items.keys.contains(id) else {
                return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
            }

            DatabaseMock.tables[item.table, default: Table(name: item.table)].items[id] = item
        }

        return eventLoop.makeSucceededFuture(())
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

    func getAllSummaries(forID summaryID: String, tableName: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "GetAllSummaries summaryID: \(summaryID))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: summaryID))
        }

        return eventLoop.makeSucceededFuture(items.filter { ($0.attributes["summaryID"] as? String) == summaryID } )
    }

    mutating func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "Update items: \(items))")

        for item in items {
            guard let itemID = item.key["itemID"]?.value else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveItemID)
            }

            guard let summaryID = item.key["summaryID"]?.value else {
                return eventLoop.makeFailedFuture(DatabaseError.itemDoesNotHaveSummaryID)
            }

            let id = "\(itemID)|\(summaryID)"

            guard
                item.conditionExpression == nil ||
                DatabaseMock.tables[item.table]?.items.keys.contains(id) ?? false else {
                return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
            }

            let updatedItem = DatabasePutItem(item.attributes, table: item.table)
            DatabaseMock.tables[item.table, default: Table(name: item.table)].items[id] = updatedItem
        }

        return eventLoop.makeSucceededFuture(())
    }

}
