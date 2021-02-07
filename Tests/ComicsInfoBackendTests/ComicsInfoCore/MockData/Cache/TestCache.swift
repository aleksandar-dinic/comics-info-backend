//
//  TestCache.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

final class TestCache<Item: ComicInfoItem>: Cacheable {
    
    private var itemsCaches: [String: [String: Codable]]
    private var itemsSummaries: [String: [String: Codable]]

    public init(
        itemsCaches: [String: [String: Codable]] = [:],
        itemsSummaries: [String: [String: Codable]] = [:]
    ) {
        self.itemsCaches = itemsCaches
        self.itemsSummaries = itemsSummaries
    }
    
    func getItem(withID itemID: Item.ID, from table: String) -> Result<Item, CacheError<Item>> {
        guard let cache = itemsCaches[table], let item = cache[itemID] as? Item else {
            return .failure(.itemNotFound(withID: itemID, itemType: Item.self))
        }

        return .success(item)
    }
    
    func getItems(withIDs IDs: Set<Item.ID>, from table: String) -> (items: [Item], missingIDs: Set<Item.ID>) {
        var items = [Item]()
        guard let cache = itemsCaches[table], !cache.isEmpty else { return (items, IDs) }
        
        for id in IDs {
            guard let item = cache[id] as? Item else { continue }
            items.append(item)
        }

        return (items, Set(items.map({ $0.id })).symmetricDifference(IDs))
    }
    
    func getAllItems(from table: String) -> Result<[Item], CacheError<Item>> {
        guard let cache = itemsCaches[table], !cache.isEmpty else {
            return .failure(.itemsNotFound(itemType: Item.self))
        }

        let items = cache.values.compactMap { $0 as? Item }
        guard !items.isEmpty else {
            return .failure(.itemsNotFound(itemType: Item.self))
        }
        
        return .success(items)
    }
    
    func save(items: [Item], in table: String) {
        for item in items {
            itemsCaches[table, default: [:]][item.id] = item
        }
    }
    
    func getSummaries<Summary: ItemSummary>(forID ID: String, from table: String) -> Result<[Summary], CacheError<Item>> {
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
    
    func save<Summary>(summaries: [Summary], in table: String) where Summary : ItemSummary {
        for summary in summaries {
            let id = "\(summary.itemID)|\(summary.summaryID)"
            itemsSummaries[table, default: [:]][id] = summary
        }
    }
    
}
