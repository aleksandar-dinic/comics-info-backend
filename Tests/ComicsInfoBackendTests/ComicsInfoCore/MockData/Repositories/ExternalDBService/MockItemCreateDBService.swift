//
//  MockItemCreateDBService.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct MockItemCreateDBService: ItemCreateDBService {
    
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
    
    func create<Item: ComicInfoItem>(_ query: CreateItemQuery<Item>) -> EventLoopFuture<Item> {
        let mockQuery = query.mockDBQuery
        guard TestDatabase.items[mockQuery.id] == nil else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: mockQuery.id))
        }

        do {
            let encodedItem = try JSONEncoder().encode(mockQuery.item)
            TestDatabase.items[mockQuery.id] = encodedItem
            return eventLoop.submit { mockQuery.item }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    func createSummaries<Summary: ItemSummary>(_ query: CreateSummariesQuery<Summary>) -> EventLoopFuture<[Summary]> {
        do {
            for summary in query.summaries {
                let id = "\(summary.itemID)|\(summary.summaryID)"
                guard TestDatabase.items[id] == nil else {
                    return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
                }
                
                let encodedSummary = try JSONEncoder().encode(summary)
                TestDatabase.items[id] = encodedSummary
            }
            return eventLoop.submit { query.summaries }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
}
