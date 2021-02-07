//
//  InMemoryCacheProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class InMemoryCacheProvider<Item: ComicInfoItem>: Cacheable {

    private var itemsCaches: [String: InMemoryCache<Item.ID, Item>]
    private var itemsSummaries: [String: [String: Codable]]

    public init(
        itemsCaches: [String: InMemoryCache<Item.ID, Item>] = [:],
        itemsSummaries: [String: [String: Codable]] = [:]
    ) {
        self.itemsCaches = itemsCaches
        self.itemsSummaries = itemsSummaries
    }

    public func getItem(withID itemID: Item.ID, from table: String) -> Result<Item, CacheError<Item>> {
        guard let cache = itemsCaches[table], let item = cache[itemID] else {
            return .failure(.itemNotFound(withID: itemID, itemType: Item.self))
        }

        return .success(item)
    }

    public func getItems(withIDs IDs: Set<Item.ID>, from table: String) -> (items: [Item], missingIDs: Set<Item.ID>) {
        print("InMemoryCacheProvider getItems withIDs: \(IDs)")
        var items = [Item]()
        guard let cache = itemsCaches[table], !cache.isEmpty else {
            print("InMemoryCacheProvider getItems missingIDs: \(IDs)")
            return (items, IDs)
        }
        
        for id in IDs {
            guard let item = cache[id] else { continue }
            items.append(item)
        }

        print("InMemoryCacheProvider getItems missingIDs: \(Set(items.map({ $0.id })).symmetricDifference(IDs))")
        return (items, Set(items.map({ $0.id })).symmetricDifference(IDs))
    }
    
    public func getAllItems(from table: String) -> Result<[Item], CacheError<Item>> {
        guard let cache = itemsCaches[table], !cache.isEmpty else {
            return .failure(.itemsNotFound(itemType: Item.self))
        }

        return .success(cache.values)
    }

    public func save(items: [Item], in table: String) {
        for item in items {
            if itemsCaches[table] == nil {
                itemsCaches[table] = InMemoryCache<Item.ID, Item>()
            }
            itemsCaches[table]?[item.id] = item
        }
    }
    
    public func getSummaries<Summary: ItemSummary>(forID ID: String, from table: String) -> Result<[Summary], CacheError<Item>> {
        guard let cache = itemsSummaries[table], !cache.isEmpty else {
            return .failure(.summariesNotFound(String.getType(from: Summary.self)))
        }
        
        var items = [Summary]()
        for (_, el) in cache.enumerated() {
            guard el.key.hasSuffix(ID), let item = el.value as? Summary else { continue }
            items.append(item)
        }

        return !items.isEmpty ? .success(items) : .failure(.summariesNotFound(String.getType(from: Summary.self)))
    }
    
    public func save<Summary: ItemSummary>(summaries: [Summary], in table: String) {
        for summary in summaries {
            let id = "\(summary.itemID)|\(summary.summaryID)"
            itemsSummaries[table, default: [:]][id] = summary
        }
    }

}
