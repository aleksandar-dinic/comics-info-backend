//
//  InMemoryCacheProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct InMemoryCacheProvider<Item: Codable & DatabaseDecodable>: Cacheable {

    private let inMemoryCache: InMemoryCache<Item.ID, Item>

    public init(_ inMemoryCache: InMemoryCache<Item.ID, Item> = InMemoryCache()) {
        self.inMemoryCache = inMemoryCache
    }

    public func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[Item]> {
        let promise = eventLoop.makePromise(of: [Item].self)

        eventLoop.execute {
            guard !inMemoryCache.isEmpty else {
                return promise.fail(APIError.itemsNotFound)
            }

            promise.succeed(inMemoryCache.values)
        }

        return promise.futureResult
    }

    public func get(
        withID identifier: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        let promise = eventLoop.makePromise(of: Item.self)

        eventLoop.execute {
            guard let item = inMemoryCache[identifier] else {
                return promise.fail(APIError.itemNotFound)
            }
            promise.succeed(item)
        }

        return promise.futureResult
    }

    public func save(items: [Item]) {
        for item in items {
            inMemoryCache[item.identifier] = item
        }
    }

}

