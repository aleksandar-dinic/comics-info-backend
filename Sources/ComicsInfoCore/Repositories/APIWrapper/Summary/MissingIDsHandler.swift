//
//  MissingIDsHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol MissingIDsHandler {
    
    func handleMissingIDs<Item: ComicInfoItem>(_ items: [Item], IDs: Set<String>) throws -> [Item]
    
}

extension MissingIDsHandler {
    
    func handleMissingIDs<Item: ComicInfoItem>(_ items: [Item], IDs: Set<String>) throws -> [Item] {
        let missingIDs = Set(items.map({ $0.id })).symmetricDifference(IDs)
    
        guard missingIDs.isEmpty else {
            throw DatabaseError.itemsNotFound(withIDs: missingIDs)
        }
    
        return items
    }
    
}
