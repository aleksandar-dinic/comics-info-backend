//
//  ComicInfoItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol ComicInfoItem: Identifiable, Codable, Comparable where ID == String {
    
    var itemID: String { get }
    var sortValue: String { get }
    var itemType: String { get }
    var popularity: Int { get }
    
    mutating func update(with newItem: Self)
    
}

public extension ComicInfoItem {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.sortValue < rhs.sortValue
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.itemID == rhs.itemID
    }
    
}

extension ComicInfoItem {
    
    func update(_ items: [String]?, with newItems: [String]?) -> [String]? {
        var tmp = Set(items ?? [])
        for item in newItems ?? [] {
            tmp.insert(item)
        }
        return !tmp.isEmpty ? Array(tmp).sorted() : nil
    }
    
    func updatedFields(old: Any) -> Set<String> {
        let oldMirror = Mirror(reflecting: old)

        var oldDict = [String: Any]()
        for child in oldMirror.children {
            guard let label = child.label else { continue }
            oldDict[label] = child.value
        }
        
        let newMirror = Mirror(reflecting: self)
        var updated = Set<String>()
        
        for new in newMirror.children {
            guard let label = new.label, let oldVal = oldDict[label] else { continue }
            guard
                (isType(type: Int.self, lhs: oldVal, rhs: new.value) &&
                !isEqual(type: Int.self, lhs: oldVal, rhs: new.value)) ||
                    
                (isType(type: String.self, lhs: oldVal, rhs: new.value) &&
                !isEqual(type: String.self, lhs: oldVal, rhs: new.value)) ||
                    
                (isType(type: [SeriesSummary].self, lhs: oldVal, rhs: new.value) &&
                !isEqual(type: [SeriesSummary].self, lhs: oldVal, rhs: new.value)) ||
            
                (isNil(oldVal) && !isNil(new.value))
            else { continue }
            updated.insert(label)
        }
        
        return updated
    }
    
    private func isNil(_ value: Any) -> Bool {
        switch value {
        case Optional<Any>.none:
            return true
        default:
            return false
        }
    }
    
    private func isType<T: Equatable>(type: T.Type, lhs: Any, rhs: Any) -> Bool {
        guard lhs is T, rhs is T else { return false }
        return true
    }
    
    private func isEqual<T: Equatable>(type: T.Type, lhs: Any, rhs: Any) -> Bool {
        guard let lhs = lhs as? T, let rhs = rhs as? T else { return false }

        return lhs == rhs
    }
    
}
