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

    func create(_ item: Item) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.create(item)
    }

    // Get all items

    func getAllItems(fromDataSource dataSource: DataSourceLayer) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllItemsFromMemory()

        case .database:
            return getAllItemsFromDatabase()
        }
    }

    private func getAllItemsFromMemory() -> EventLoopFuture<[Item]> {
        cacheProvider.getAllItems(on: eventLoop).flatMapError { _ in
            getAllItemsFromDatabase()
        }
    }

    private func getAllItemsFromDatabase() -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAllItems().always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items)
        }
    }

    // Get item.

    public func getItem(
        withID itemID: Item.ID,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item> {
        switch dataSource {
        case .memory:
            return getItemFromMemory(withID: itemID)

        case .database:
            return getItemFromDatabase(withID: itemID)
        }
    }

    private func getItemFromMemory(withID itemID: Item.ID) -> EventLoopFuture<Item>  {
        cacheProvider.getItem(withID: itemID, on: eventLoop).flatMapError { _ in
            getItemFromDatabase(withID: itemID)
        }
    }

    private func getItemFromDatabase(withID itemID: Item.ID) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.getItem(withID: itemID).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.save(items: [item])
        }
    }

    // Get item metadata

    func getMetadata(
        withID id: Item.ID,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Item> {
        switch dataSource {
        case .memory:
            return getMetadataFromMemory(withID: id)

        case .database:
            return getMetadataFromDatabase(withID: id)
        }
    }

    private func getMetadataFromMemory(withID id: Item.ID) -> EventLoopFuture<Item>  {
        cacheProvider.getMetadata(withID: id, on: eventLoop).flatMapError { _ in
            getMetadataFromDatabase(withID: id)
        }
    }

    private func getMetadataFromDatabase(withID id: Item.ID) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.getMetadata(id: id).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.save(items: [item])
        }
    }

    // Get list of items metadata

    func getAllMetadata(
        withIDs ids: Set<Item.ID>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllMetadataFromMemory(withIDs: ids)

        case .database:
            return getAllMetadataFromDatabase(withIDs: ids)
        }
    }

    private func getAllMetadataFromMemory(withIDs ids: Set<Item.ID>) -> EventLoopFuture<[Item]>  {
        cacheProvider.getAllMetadata(withIDs: ids, on: eventLoop).flatMapError { _ in
            getAllMetadataFromDatabase(withIDs: ids)
        }
    }

    private func getAllMetadataFromDatabase(withIDs ids: Set<Item.ID>) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAllMetadata(ids: ids).always { result in
            guard let item = try? result.get() else { return }
            cacheProvider.save(items: item)
        }
    }

}
