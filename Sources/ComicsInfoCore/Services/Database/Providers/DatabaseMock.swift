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
    private let tableName: String
    private let logger: Logger

    init(eventLoop: EventLoop, tableName: String, logger: Logger) {
        self.eventLoop = eventLoop
        self.tableName = tableName
        self.logger = logger
    }

    mutating func create(_ item: DatabasePutItem) -> EventLoopFuture<Void> {
        logger.log(level: .info, "item: \(item))")

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
        logger.log(level: .info, "items: \(items))")

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

    func getItem(withID itemID: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "withID: \(itemID))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: itemID))
        }

        return eventLoop.makeSucceededFuture(items.filter({ $0.attributes["itemID"] as? String == itemID }))
    }

    func getAll(_ items: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "items: \(items))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.makeSucceededFuture(items)
    }

    func getMetadata(withID id: String) -> EventLoopFuture<DatabaseItem> {
        logger.log(level: .info, "withID: \(id))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard let item = items.first(where: { $0.attributes["itemID"] as? String == id }) else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: id))
        }

        return eventLoop.makeSucceededFuture(item)
    }

    func getAllMetadata(withIDs ids: Set<String>) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "withIDs: \(ids))")

        var items = [DatabaseItem]()
        for id in ids {
            let table = getTable(from: id)
            guard let item = DatabaseMock.tables[table]?.items["\(id)|\(id)"] else { continue }
            items.append(item)
        }

        return eventLoop.makeSucceededFuture(items)
    }

    private func getTable(from itemID: String) -> String {
        if itemID.starts(with: String.getType(from: Character.self)) {
            return String(itemID.dropLast(itemID.count - "\(String.getType(from: Character.self))".count))

        } else if itemID.starts(with: String.getType(from: Series.self)) {
            return String(itemID.dropLast(itemID.count - "\(String.getType(from: Series.self))".count))

        } else if itemID.starts(with: String.getType(from: Comic.self)) {
            return String(itemID.dropLast(itemID.count - "\(String.getType(from: Comic.self))".count))
        }

        return ""
    }

    func getAllSummaries(forID summaryID: String) -> EventLoopFuture<[DatabaseItem]> {
        logger.log(level: .info, "summaryID: \(summaryID))")

        var items = [DatabaseItem]()
        items = DatabaseMock.tables[tableName]?.items.values.map { $0 } ?? []

        guard !items.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: summaryID))
        }

        return eventLoop.makeSucceededFuture(items.filter { ($0.attributes["summaryID"] as? String) == summaryID } )
    }

    mutating func update(_ items: [DatabaseUpdateItem]) -> EventLoopFuture<Void> {
        logger.log(level: .info, "items: \(items))")

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
