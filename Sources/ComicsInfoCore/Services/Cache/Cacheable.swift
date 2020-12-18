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

    associatedtype Item: Codable & Identifiable

    func getItem(
        withID itemID: Item.ID,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item>

    func getAllItems(
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]>

    func getMetadata(
        withID id: Item.ID,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item>

    func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        from table: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]>

    func save(items: [Item], in table: String)
    func saveMetadata(items: [Item], in table: String)

}
