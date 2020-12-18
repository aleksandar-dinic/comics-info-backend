//
//  InMemoryCacheProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class InMemoryCacheProvider<Item: Codable & Identifiable>: Cacheable {

    private var itemsCaches: [String: InMemoryCache<Item.ID, Item>]
    private var metadataCaches: [String: InMemoryCache<Item.ID, Item>]

    public init(
        itemsCaches: [String: InMemoryCache<Item.ID, Item>] = [:],
        metadataCaches: [String: InMemoryCache<Item.ID, Item>] = [:]
    ) {
        self.itemsCaches = itemsCaches
        self.metadataCaches = metadataCaches
    }

    public func getItem(
        withID itemID: Item.ID,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        let promise = eventLoop.makePromise(of: Item.self)

        eventLoop.execute {
            guard let cache = self.itemsCaches[table], let item = cache[itemID] else {
                return promise.fail(CacheError.itemNotFound(withID: itemID, itemType: Item.self))
            }

            promise.succeed(item)
        }

        return promise.futureResult
    }

    public func getAllItems(
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)

        eventLoop.execute {
            guard let cache = self.itemsCaches[table], !cache.isEmpty else {
                return promise.fail(CacheError.itemsNotFound(itemType: Item.self))
            }

            promise.succeed(cache.values)
        }

        return promise.futureResult
    }

    public func getMetadata(
        withID id: Item.ID,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        let promise = eventLoop.makePromise(of: Item.self)

        eventLoop.execute {
            guard let cache = self.metadataCaches[table], let item = cache[id] else {
                return promise.fail(CacheError.itemNotFound(withID: id, itemType: Item.self))
            }
            promise.succeed(item)
        }

        return promise.futureResult
    }

    public func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)

        eventLoop.execute {
            guard !ids.isEmpty else {
                return promise.fail(CacheError.itemsNotFound(itemType: Item.self))
            }

            var items = [Item]()
            for id in ids {
                guard let cache = self.metadataCaches[table], let item = cache[id] else { continue }
                items.append(item)
            }

            if items.count == ids.count {
                promise.succeed(items)
            } else {
                promise.fail(CacheError.itemsNotFound(itemType: Item.self))
            }
        }

        return promise.futureResult
    }

    public func save(items: [Item], in table: String) {
        for item in items {
            if itemsCaches[table] == nil {
                itemsCaches[table] = InMemoryCache<Item.ID, Item>()
            }
            itemsCaches[table]?[item.id] = item

            if metadataCaches[table] == nil {
                metadataCaches[table] = InMemoryCache<Item.ID, Item>()
            }
            metadataCaches[table]?[item.id] = item
        }
    }

    public func saveMetadata(items: [Item], in table: String) {
        for item in items {
            if metadataCaches[table] == nil {
                metadataCaches[table] = InMemoryCache<Item.ID, Item>()
            }
            metadataCaches[table]?[item.id] = item
        }
    }

}
