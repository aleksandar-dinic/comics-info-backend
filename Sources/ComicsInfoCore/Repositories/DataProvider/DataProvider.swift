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

    let eventLoop: EventLoop
    let repositoryAPIWrapper: APIWrapper
    let cacheProvider: CacheProvider

    // Get item.

    public func getItem(
        withID itemID: Item.ID,
        dataSource: DataSourceLayer,
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
        switch cacheProvider.getItem(withID: itemID, from: table) {
        case let .success(item):
            return eventLoop.submit { item }
            
        case .failure:
            return getItemFromDatabase(withID: itemID, from: table)
        }
    }

    private func getItemFromDatabase(withID itemID: Item.ID, from table: String) -> EventLoopFuture<Item> {
        repositoryAPIWrapper.getItem(withID: itemID, from: table)
            .always { result in
                guard let item = try? result.get() else { return }
                cacheProvider.save(items: [item], in: table)
            }
    }
    
    // Get Items
    
    func getItems(
        withIDs IDs: Set<Item.ID>,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getItemsFromMemory(withIDs: IDs, from: table)
        case .database:
            return getItemsFromDatabase(withIDs: IDs, from: table)
        }
    }
    
    private func getItemsFromMemory(withIDs IDs: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]>  {
        let (items, missingIDs) = cacheProvider.getItems(withIDs: IDs, from: table)
        
        guard !missingIDs.isEmpty else {
            return eventLoop.submit { items }
        }
            
        return getItemsFromDatabase(withIDs: missingIDs, from: table)
            .map { $0 + items }
            .always { result in
                guard let items = try? result.get() else { return }
                cacheProvider.save(items: items, in: table)
            }
    }

    private func getItemsFromDatabase(withIDs IDs: Set<Item.ID>, from table: String) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getItems(withIDs: IDs, from: table)
            .always { result in
                guard let items = try? result.get() else { return }
                cacheProvider.save(items: items, in: table)
            }
    }

    
    // Get all items

    func getAllItems(dataSource: DataSourceLayer, from table: String) -> EventLoopFuture<[Item]> {
        switch dataSource {
        case .memory:
            return getAllItemsFromMemory(from: table)

        case .database:
            return getAllItemsFromDatabase(from: table)
        }
    }

    private func getAllItemsFromMemory(from table: String) -> EventLoopFuture<[Item]> {
        switch cacheProvider.getAllItems(from: table) {
        case let .success(items):
            return eventLoop.submit { items }
            
        case .failure:
            return getAllItemsFromDatabase(from: table)
        }
    }

    private func getAllItemsFromDatabase(from table: String) -> EventLoopFuture<[Item]> {
        repositoryAPIWrapper.getAllItems(from: table).always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items, in: table)
        }
    }
    
    // Get Summaries
     
    func getSummaries<Summary: ItemSummary>(
        _ type: Summary.Type,
        forID ID: String,
        dataSource: DataSourceLayer,
        from table: String
    ) -> EventLoopFuture<[Summary]?> {
        switch dataSource {
        case .memory:
            return getSummariesFromMemory(type, forID: ID, from: table)

        case .database:
            return getSummariesFromDatabase(type, forID: ID, from: table)
        }
    }
    
    private func getSummariesFromMemory<Summary: ItemSummary>(
        _ type: Summary.Type,
        forID ID: String,
        from table: String
    ) -> EventLoopFuture<[Summary]?> {
        switch cacheProvider.getSummaries(type, forID: ID, from: table) {
        case let .success(items):
            return eventLoop.submit { items }

        case .failure:
            return getSummariesFromDatabase(type, forID: ID, from: table)
        }
    }
    
    private func getSummariesFromDatabase<Summary: ItemSummary>(
        _ type: Summary.Type,
        forID ID: String,
        from table: String
    ) -> EventLoopFuture<[Summary]?> {
        repositoryAPIWrapper.getSummaries(type, forID: ID, from: table).always { result in
            guard let summaries = try? result.get() else { return }
            cacheProvider.save(summaries: summaries, in: table)
        }
    }
    
}
