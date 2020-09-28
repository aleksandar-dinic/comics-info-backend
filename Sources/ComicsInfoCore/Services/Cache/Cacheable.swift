//
//  InMemoryCacheService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol Cacheable {

    associatedtype Item: Codable & DatabaseDecodable

    func getAll(on eventLoop: EventLoop) -> EventLoopFuture<[Item]>
    func get(withID identifier: Item.ID, on eventLoop: EventLoop) -> EventLoopFuture<Item>
    func save(items: [Item])

}
