//
//  ComicInfoItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol ComicInfoItem: Identifiable, Codable where ID == String {
    
    var itemID: String { get }
    var summaryID: String { get }
    var itemName: String { get }
    
}

extension ComicInfoItem {
    
    func updatedFields(old: Any) -> Set<String> {
        let newMirror = Mirror(reflecting: self)

        var newDict = [String: Any]()
        for child in newMirror.children {
            guard let label = child.label else { continue }
            newDict[label] = child.value
        }
        
        let oldMirror = Mirror(reflecting: old)
        var updated = Set<String>()
        
        for child in oldMirror.children {
            guard let label = child.label, let oldVal = newDict[label] else { continue }
            guard
                (isType(type: Int.self, lhs: oldVal, rhs: child.value) &&
                !isEqual(type: Int.self, lhs: oldVal, rhs: child.value)) ||
                    
                (isType(type: String.self, lhs: oldVal, rhs: child.value) &&
                !isEqual(type: String.self, lhs: oldVal, rhs: child.value))
            else { continue }
            updated.insert(label)
        }
        
        return updated
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
