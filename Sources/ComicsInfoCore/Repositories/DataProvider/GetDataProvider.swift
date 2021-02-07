//
//  GetDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct GetDataProvider<Item, CacheProvider: Cacheable> where CacheProvider.Item == Item {

    let eventLoop: EventLoop
    let itemGetDBWrapper: ItemGetDBWrapper<Item>
    let cacheProvider: CacheProvider

    // Get item.

    public func getItem(with criteria: GetItemCriteria) -> EventLoopFuture<Item> {
        switch criteria.dataSource {
        case .memory:
            return getItemFromMemory(with: criteria)

        case .database:
            return getItemFromDatabase(with: criteria)
        }
    }

    private func getItemFromMemory(with criteria: GetItemCriteria) -> EventLoopFuture<Item>  {
        switch cacheProvider.getItem(withID: criteria.itemID, from: criteria.table) {
        case let .success(item):
            return eventLoop.submit { item }
            
        case .failure:
            return getItemFromDatabase(with: criteria)
        }
    }

    private func getItemFromDatabase(with criteria: GetItemCriteria) -> EventLoopFuture<Item> {
        itemGetDBWrapper.getItem(withID: criteria.itemID, from: criteria.table)
            .always { result in
                guard let item = try? result.get() else { return }
                cacheProvider.save(items: [item], in: criteria.table)
            }
    }
    
    // Get Items
    
    func getItems(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]> {
        switch criteria.dataSource {
        case .memory:
            return getItemsFromMemory(withIDs: criteria.IDs, from: criteria.table)
        case .database:
            return getItemsFromDatabase(withIDs: criteria.IDs, from: criteria.table)
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
        itemGetDBWrapper.getItems(withIDs: IDs, from: table)
            .always { result in
                guard let items = try? result.get() else { return }
                cacheProvider.save(items: items, in: table)
            }
    }

    
    // Get all items

    func getAllItems(with criteria: GetAllItemsCriteria) -> EventLoopFuture<[Item]> {
        switch criteria.dataSource {
        case .memory:
            return getAllItemsFromMemory(from: criteria.table)

        case .database:
            return getAllItemsFromDatabase(from: criteria.table)
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
        itemGetDBWrapper.getAllItems(from: table).always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items, in: table)
        }
    }
    
    // Get Summaries
     
    func getSummaries<Summary: ItemSummary>(with criteria: GetSummariesCriteria) -> EventLoopFuture<[Summary]?> {
        switch criteria.dataSource {
        case .memory:
            return getSummariesFromMemory(forID: criteria.ID, from: criteria.table, by: criteria.key)

        case .database:
            return getSummariesFromDatabase(forID: criteria.ID, from: criteria.table, by: criteria.key)
        }
    }
    
    private func getSummariesFromMemory<Summary: ItemSummary>(
        forID ID: String,
        from table: String,
        by key: PartitionKey
    ) -> EventLoopFuture<[Summary]?>  {
        let result: Result<[Summary], CacheError<Item>> = cacheProvider.getSummaries(forID: ID, from: table)
        
        switch result {
        case let .success(items):
            return eventLoop.submit { items }

        case .failure:
            return getSummariesFromDatabase(forID: ID, from: table, by: key)
        }
    }
    
    private func getSummariesFromDatabase<Summary: ItemSummary>(
        forID ID: String,
        from table: String,
        by key: PartitionKey
    ) -> EventLoopFuture<[Summary]?> {
        itemGetDBWrapper.getSummaries(forID: ID, from: table, by: key).always { result in
            guard let summaries = try? result.get() else { return }
            cacheProvider.save(summaries: summaries, in: table)
        }
    }
    
}
