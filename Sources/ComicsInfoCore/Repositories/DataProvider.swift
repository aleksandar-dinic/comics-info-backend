//
//  DataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct DataProvider<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable> where APIWrapper.Item == CacheProvider.Item {

    typealias Item = CacheProvider.Item

    private let repositoryAPIWrapper: APIWrapper
    private let cacheProvider: CacheProvider

    init(
        repositoryAPIWrapper: APIWrapper,
        cacheProvider: CacheProvider
    ) {
        self.repositoryAPIWrapper = repositoryAPIWrapper
        self.cacheProvider = cacheProvider
    }

    // Create item.

    func create(_ item: Item) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.create(item)
    }

    // Get all items

    func getAll(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllItemsFromMemory(on: eventLoop)

        case .database:
            return getAllItemsFromDatabase(on: eventLoop)
        }
    }

    private func getAllItemsFromMemory(on eventLoop: EventLoop) -> EventLoopFuture<[Item]> {
        cacheProvider.getAll(on: eventLoop).flatMapError { _ in
            getAllItemsFromDatabase(on: eventLoop)
        }
    }

    private func getAllItemsFromDatabase(on eventLoop: EventLoop) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAll(on: eventLoop).always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items)
        }
    }

    // Get item

    func get(
        withID identifier: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        switch dataSource {
        case .memory:
            return getItemFromMemory(withID: identifier, on: eventLoop)

        case .database:
            return getItemFromDatabase(withID: identifier, on: eventLoop)
        }
    }

    private func getItemFromMemory(
        withID identifier: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item>  {
        cacheProvider.get(withID: identifier, on: eventLoop).flatMapError { _ in
            getItemFromDatabase(withID: identifier, on: eventLoop)
        }
    }

    private func getItemFromDatabase(
        withID identifier: Item.ID,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.get(withID: identifier, on: eventLoop).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.save(items: [item])
        }
    }

}
