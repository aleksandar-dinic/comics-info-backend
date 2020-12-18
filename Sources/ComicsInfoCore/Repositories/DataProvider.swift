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

    private let eventLoop: EventLoop
    private let repositoryAPIWrapper: APIWrapper
    private let cacheProvider: CacheProvider

    init(
        on eventLoop: EventLoop,
        repositoryAPIWrapper: APIWrapper,
        cacheProvider: CacheProvider
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIWrapper = repositoryAPIWrapper
        self.cacheProvider = cacheProvider
    }

    // Create item.

    func create(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.create(item, in: table)
    }

    // Get all items

    func getAllItems(
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllItemsFromMemory(from: table)

        case .database:
            return getAllItemsFromDatabase(from: table)
        }
    }

    private func getAllItemsFromMemory(from table: String) -> EventLoopFuture<[Item]> {
        cacheProvider.getAllItems(from: table, on: eventLoop).flatMapError { _ in
            getAllItemsFromDatabase(from: table)
        }
    }

    private func getAllItemsFromDatabase(from table: String) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAllItems(from: table).always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items, in: table)
        }
    }

    // Get item.

    public func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item> {
        switch dataSource {
        case .memory:
            return getItemFromMemory(withID: itemID, from: table)

        case .database:
            return getItemFromDatabase(withID: itemID, from: table)
        }
    }

    private func getItemFromMemory(withID itemID: Item.ID, from table: String) -> EventLoopFuture<Item>  {
        cacheProvider.getItem(withID: itemID, from: table, on: eventLoop).flatMapError { _ in
            getItemFromDatabase(withID: itemID, from: table)
        }
    }

    private func getItemFromDatabase(withID itemID: Item.ID, from table: String) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.getItem(withID: itemID, from: table).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.save(items: [item], in: table)
        }
    }

    // Get item metadata

    func getMetadata(
        withID id: Item.ID,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<Item> {
        switch dataSource {
        case .memory:
            return getMetadataFromMemory(withID: id, from: table)

        case .database:
            return getMetadataFromDatabase(withID: id, from: table)
        }
    }

    private func getMetadataFromMemory(
        withID id: Item.ID,
        from table: String
    ) -> EventLoopFuture<Item>  {
        cacheProvider.getMetadata(withID: id, from: table, on: eventLoop).flatMapError { _ in
            getMetadataFromDatabase(withID: id, from: table)
        }
    }

    private func getMetadataFromDatabase(
        withID id: Item.ID,
        from table: String
    ) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.getMetadata(id: id, from: table).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.saveMetadata(items: [item], in: table)
        }
    }

    // Get list of items metadata

    func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        fromDataSource dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllMetadataFromMemory(withIDs: ids, from: table)

        case .database:
            return getAllMetadataFromDatabase(withIDs: ids, from: table)
        }
    }

    private func getAllMetadataFromMemory(
        withIDs ids: Set<Item.ID>,
        from table: String
    ) -> EventLoopFuture<[Item]>  {
        cacheProvider.getAllMetadata(withIDs: ids, from: table, on: eventLoop).flatMapError { _ in
            getAllMetadataFromDatabase(withIDs: ids, from: table)
        }
    }

    private func getAllMetadataFromDatabase(
        withIDs ids: Set<Item.ID>,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAllMetadata(ids: ids, from: table).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.saveMetadata(items: item, in: table)
        }
    }

    // Update item

    func update(_ item: Item, in table: String) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.update(item, in: table)
    }

}
