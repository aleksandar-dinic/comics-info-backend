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
    
    func getItem<Item: ComicInfoItem>(withID ID: String, from table: String) -> EventLoopFuture<Item> {
        guard let data = TestDatabase.items[ID] else {
            return eventLoop.makeFailedFuture(DatabaseError.itemNotFound(withID: ID))
        }
        
        do {
            let item = try JSONDecoder().decode(Item.self, from: data)
            return eventLoop.submit { item }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    func getItems<Item: ComicInfoItem>(withIDs IDs: Set<String>, from table: String) -> EventLoopFuture<[Item]> {
        var items = [Item]()
        for id in IDs {
            guard let data = TestDatabase.items[id],
                  let item = try? JSONDecoder().decode(Item.self, from: data) else { continue }
            items.append(item)
        }

        guard items.count == IDs.count else {
            return eventLoop.makeFailedFuture(
                DatabaseError.itemsNotFound(withIDs: Set(items.map({ $0.itemID })).symmetricDifference(IDs))
            )
        }
        
        return eventLoop.submit { items }
    }
    
    func getAll<Item: ComicInfoItem>(_ items: String, from table: String) -> EventLoopFuture<[Item]> {
        var databaseItems = [Item]()
        for value in TestDatabase.items.values {
            guard let item = try? JSONDecoder().decode(Item.self, from: value),
                  item.itemName == items else { continue }
            databaseItems.append(item)
        }

        guard !databaseItems.isEmpty else {
            return eventLoop.makeFailedFuture(DatabaseError.itemsNotFound(withIDs: nil))
        }

        return eventLoop.submit { databaseItems }
    }
    
    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        
        var items = [Summary]()
        for (_, el) in TestDatabase.items.enumerated() {
            guard criteria.isValidKey(el.key),
                  let item = try? JSONDecoder().decode(Summary.self, from: el.value),
                  item.itemName == criteria.itemName
            else { continue }
            items.append(item)
        }
        
        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
    func getSummary<Summary: ItemSummary>(
        with criteria: [GetSummaryCriteria<Summary>]
    ) -> EventLoopFuture<[Summary]?> {
        var items = [Summary]()
        for criterion in criteria {
            guard let data = DatabaseMock.items["\(criterion.itemID)|\(criterion.summaryID)"],
                  let item = try? JSONDecoder().decode(Summary.self, from: data) else { continue }
            items.append(item)
        }

        return eventLoop.submit { !items.isEmpty ? items : nil }
    }
    
}
