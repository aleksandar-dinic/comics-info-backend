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
        switch cacheProvider.getItem(withID: criteria.ID, from: criteria.table) {
        case let .success(item):
            return eventLoop.submit { item }
            
        case .failure:
            return getItemFromDatabase(with: criteria)
        }
    }

    private func getItemFromDatabase(with criteria: GetItemCriteria) -> EventLoopFuture<Item> {
        itemGetDBWrapper.getItem(with: criteria)
            .always { result in
                guard let item = try? result.get() else { return }
                cacheProvider.save(items: [item], in: criteria.table)
            }
    }
    
    // Get Items
    
    func getItems(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]> {
        switch criteria.dataSource {
        case .memory:
            return getItemsFromMemory(with: criteria)
        case .database:
            return getItemsFromDatabase(with: criteria)
        }
    }
    
    private func getItemsFromMemory(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]>  {
        let (items, missingIDs) = cacheProvider.getItems(withIDs: criteria.IDs, from: criteria.table)
        
        guard !missingIDs.isEmpty else {
            return eventLoop.submit { items }
        }
        
        let newCriteria = GetItemsCriteria(IDs: missingIDs, dataSource: .database, table: criteria.table)
        return getItemsFromDatabase(with: newCriteria)
            .map { $0 + items }
            .always { result in
                guard let items = try? result.get() else { return }
                cacheProvider.save(items: items, in: criteria.table)
            }
    }

    private func getItemsFromDatabase(with criteria: GetItemsCriteria) -> EventLoopFuture<[Item]> {
        itemGetDBWrapper.getItems(with: criteria)
            .always { result in
                guard let items = try? result.get() else { return }
                cacheProvider.save(items: items, in: criteria.table)
            }
    }
    
    // Get all items

    func getAllItems(with criteria: GetAllItemsCriteria<Item>) -> EventLoopFuture<[Item]> {
        switch criteria.dataSource {
        case .memory:
            return getAllItemsFromMemory(with: criteria)

        case .database:
            return getAllItemsFromDatabase(with: criteria)
        }
    }

    private func getAllItemsFromMemory(with criteria: GetAllItemsCriteria<Item>) -> EventLoopFuture<[Item]> {
        switch cacheProvider.getAllItems(
            afterID: criteria.afterID,
            limit: criteria.limit,
            from: criteria.table
        ) {
        case let .success(items):
            guard items.count < criteria.limit else {
                return eventLoop.submit { items }
            }
            
            var criteria = criteria
            criteria.initialValue = items
            return getAllItemsFromDatabase(with: criteria)
            
        case .failure:
            return getAllItemsFromDatabase(with: criteria)
        }
    }

    private func getAllItemsFromDatabase(with criteria: GetAllItemsCriteria<Item>) -> EventLoopFuture<[Item]> {
        itemGetDBWrapper.getAllItems(with: criteria).always { result in
            guard let items = try? result.get() else { return }
            cacheProvider.save(items: items, in: criteria.table)
        }
    }
    
    // Get Summaries
     
    func getSummaries<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        switch criteria.dataSource {
        case .memory:
            return getSummariesFromMemory(with: criteria)

        case .database:
            return getSummariesFromDatabase(with: criteria)
        }
    }
    
    private func getSummariesFromMemory<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?>  {
        let result: Result<[Summary], CacheError<Item>> = cacheProvider.getSummaries(forID: criteria.ID, from: criteria.table)
        
        switch result {
        case let .success(items):
            return eventLoop.submit { items }

        case .failure:
            return getSummariesFromDatabase(with: criteria)
        }
    }
    
    private func getSummariesFromDatabase<Summary: ItemSummary>(
        with criteria: GetSummariesCriteria<Summary>
    ) -> EventLoopFuture<[Summary]?> {
        itemGetDBWrapper.getSummaries(with: criteria).always { result in
            guard let summaries = try? result.get() else { return }
            cacheProvider.save(summaries: summaries, in: criteria.table)
        }
    }
    
    // Get Summary
     
    func getSummary<Summary: ItemSummary>(with criteria: GetSummaryCriteria) -> EventLoopFuture<[Summary]?> {
        itemGetDBWrapper.getSummary(with: criteria).always { result in
            guard let summaries = try? result.get() else { return }
            cacheProvider.save(summaries: summaries, in: criteria.table)
        }
    }
        
}
