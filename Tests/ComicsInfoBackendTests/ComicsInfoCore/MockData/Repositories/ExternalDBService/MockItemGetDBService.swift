//
//  MockItemGetDBService.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct MockItemGetDBService: ItemGetDBService {
    
    private var eventLoop: EventLoop
    
    init(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        items: [String: Data] = [:]
    ) {
        self.eventLoop = eventLoop
        
        for item in items {
            TestDatabase.items[item.key] = item.value
        }
    }
    
    func getItem<Item: ComicInfoItem>(_ query: GetItemQuery) -> EventLoopFuture<Item> {
        guard let data = TestDatabase.items[query.ID] else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: query.ID))
        }
        
        do {
            let item = try JSONDecoder().decode(Item.self, from: data)
            return eventLoop.submit { item }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    func getItems<Item: ComicInfoItem>(_ query: GetItemsQuery) -> EventLoopFuture<[Item]> {
        var items = [Item]()
        for id in query.IDs {
            guard let data = TestDatabase.items[id],
                  let item = try? JSONDecoder().decode(Item.self, from: data) else { continue }
            items.append(item)
        }

        guard items.count == query.IDs.count else {
            return eventLoop.makeFailedFuture(
                DatabaseError.itemsNotFound(withIDs: Set(items.map({ $0.itemID })).symmetricDifference(query.IDs))
            )
        }
        
        return eventLoop.submit { items }
    }
    
    func getAll<Item: ComicInfoItem>(_ query: GetAllItemsQuery<Item>) -> EventLoopFuture<[Item]> {
        var databaseItems = [Item]()
        for value in TestDatabase.items.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemType == query.items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.submit { databaseItems }
    }
    
    func getAllPaginator<Item: ComicInfoItem>(_ query: GetAllItemsQuery<Item>) -> EventLoopFuture<[Item]> {
        var databaseItems = [Item]()
        for value in TestDatabase.items.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemType == query.items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.submit { databaseItems }
    }
    
    func getSummaries<Summary: ItemSummary>(_ query: GetSummariesQuery) -> EventLoopFuture<[Summary]?> {
        var items = [Summary]()
        for (_, el) in TestDatabase.items.enumerated() {
            guard query.isValidKey(el.key),
                  let item = try? JSONDecoder().decode(Summary.self, from: el.value),
                  item.itemType == query.itemType
            else { continue }
            items.append(item)
        }
        
        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
    func getSummary<Summary: ItemSummary>(_ query: GetSummaryQuery) -> EventLoopFuture<[Summary]?> {
        var items = [Summary]()
        for item in query.items {
            guard let data = MockDB["\(item.itemID)|\(item.summaryID)"],
                  let item = try? JSONDecoder().decode(Summary.self, from: data) else { continue }
            items.append(item)
        }

        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
}
