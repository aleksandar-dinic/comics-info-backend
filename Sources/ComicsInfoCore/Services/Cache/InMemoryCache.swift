//
//  InMemoryCache.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class InMemoryCache<Key: Hashable, Value: Codable> {

    private var storage: [Key: Value]
    private let queue: DispatchQueue

    public var isEmpty: Bool {
        return queue.sync {
            storage.isEmpty
        }
    }

    public var values: [Value] {
        return queue.sync {
            Array(storage.values)
        }
    }

    public init(
        storage: [Key: Value] = [Key: Value](),
        queue: DispatchQueue = DispatchQueue(label: String(describing: InMemoryCache.self), attributes: .concurrent)
    ) {
        self.storage = storage
        self.queue = queue
    }

    public subscript(key: Key) -> Value? {
        get {
            return queue.sync {
                storage[key]
            }
        }
        set {
            queue.sync(flags: .barrier) {
                storage[key] = newValue
            }
        }
    }

}
