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
        
        var items = [Item]()
        guard let cache = itemsCaches[table], !cache.isEmpty else {
            return (items, IDs)
        }
        
        for id in IDs {
            guard let item = cache[id] else { continue }
            items.append(item)
        }

        return (
            items.sorted { $0.popularity < $1.popularity },
            Set(items.map({ $0.id })
        ).symmetricDifference(IDs))
    }
    
    public func getAllItems(
        afterID: String?,
        limit: Int,
        from table: String
    ) -> Result<[Item], CacheError<Item>> {
        guard let cache = itemsCaches[table], !cache.isEmpty else {
            return .failure(.itemsNotFound(itemType: Item.self))
        }
        
        var items = cache.values.sorted()
        var start = 0
        let count = items.count
        
        if let afterID = afterID {
            guard let firstIndex = items.firstIndex(where: { $0.itemID == afterID }) else {
                return .failure(.itemsNotFound(itemType: Item.self))
            }
            start = firstIndex + 1
        }

        items = Array(items[start..<min(count, start+limit)])
        return !items.isEmpty ?
            .success(items) :
            .failure(.itemsNotFound(itemType: Item.self))
    }

    public func save(items: [Item], in table: String) {
        for item in items {
            if itemsCaches[table] == nil {
                itemsCaches[table] = InMemoryCache<Item.ID, Item>()
            }
            itemsCaches[table]?[item.id] = item
        }
    }
    
    public func getSummaries<Summary: ItemSummary>(
        forID ID: String,
        afterID: String?,
        limit: Int,
        from table: String
    ) -> Result<[Summary], CacheError<Item>> {
        guard let cache = itemsSummaries[table], !cache.isEmpty else {
            return .failure(.summariesNotFound(String.getType(from: Summary.self)))
        }
        
        var items = [Summary]()
        for (_, el) in cache.enumerated() {
            guard el.key.hasSuffix(ID), let item = el.value as? Summary else { continue }
            items.append(item)
        }
        items.sort()
        var start = 0
        let count = items.count
        
        if let afterID = afterID {
            guard let firstIndex = items.firstIndex(where: { $0.itemID == afterID }) else {
                return .failure(.itemsNotFound(itemType: Item.self))
            }
            start = firstIndex + 1
        }
        
        items = Array(items[start..<min(count, start+limit)])
        return !items.isEmpty ?
            .success(items) :
            .failure(.summariesNotFound(String.getType(from: Summary.self)))
    }
    
    public func save<Summary: ItemSummary>(summaries: [Summary], in table: String) {
        for summary in summaries {
            let id = "\(summary.itemID)|\(summary.summaryID)"
            itemsSummaries[table, default: [:]][id] = summary
        }
    }

}
