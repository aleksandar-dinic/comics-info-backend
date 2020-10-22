//
//  InMemoryCacheProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct InMemoryCacheProvider<Item: Codable & Identifiable>: Cacheable {

    private let inMemoryCache: InMemoryCache<Item.ID, Item>

    public init(_ inMemoryCache: InMemoryCache<Item.ID, Item> = InMemoryCache()) {
        self.inMemoryCache = inMemoryCache
    }

    // FIXME: - Logic between get Item and get ItemMetadata
    public func getItem(
        withID itemID: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        let promise = eventLoop.makePromise(of: Item.self)

        eventLoop.execute {
            guard let item = inMemoryCache[itemID] else {
                return promise.fail(CacheError.itemNotFound(withID: itemID, itemType: Item.self))
            }
            promise.succeed(item)
        }

        return promise.futureResult
    }

    // FIXME: - Logic between get AllItems and get AllMetadata
    public func getAllItems(on eventLoop: EventLoop) -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)

        eventLoop.execute {
            guard !inMemoryCache.isEmpty else {
                return promise.fail(CacheError.itemsNotFound(itemType: Item.self))
            }

            promise.succeed(inMemoryCache.values)
        }

        return promise.futureResult
    }

    public func getMetadata(
        withID id: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        let promise = eventLoop.makePromise(of: Item.self)

        eventLoop.execute {
            guard let item = inMemoryCache[id] else {
                return promise.fail(CacheError.itemNotFound(withID: id, itemType: Item.self))
            }
            promise.succeed(item)
        }

        return promise.futureResult
    }

    public func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)

        eventLoop.execute {
            guard !ids.isEmpty else {
                return promise.fail(CacheError.itemsNotFound(itemType: Item.self))
            }

            var items = [Item]()
            for id in ids {
                guard let item = inMemoryCache[id] else { continue }
                items.append(item)
            }

            // FIXME: -
            return items.count != ids.count ? promise.fail(CacheError.itemsNotFound(itemType: Item.self)) : promise.succeed(items)
        }

        return promise.futureResult
    }

    public func save(items: [Item]) {
        for item in items {
            inMemoryCache[item.id] = item
        }
    }

}

