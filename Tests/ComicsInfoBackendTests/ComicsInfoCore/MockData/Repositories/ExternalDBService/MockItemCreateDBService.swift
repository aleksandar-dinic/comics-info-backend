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
    
    func create<Item: ComicInfoItem>(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        guard TestDatabase.items[item.itemID] == nil else {
            return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: item.itemID))
        }

        do {
            let encodedItem = try JSONEncoder().encode(item)
            TestDatabase.items[item.itemID] = encodedItem
            return eventLoop.submit { }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    func createSummaries<Summary: ItemSummary>(_ summaries: [Summary], in table: String) -> EventLoopFuture<Void> {
        do {
            for summary in summaries {
                let id = "\(summary.itemID)|\(summary.summaryID)"
                guard TestDatabase.items[id] == nil else {
                    return eventLoop.makeFailedFuture(DatabaseError.itemAlreadyExists(withID: id))
                }
                
                let encodedSummary = try JSONEncoder().encode(summary)
                TestDatabase.items[id] = encodedSummary
            }
            return eventLoop.submit { }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
}
