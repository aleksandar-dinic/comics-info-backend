//
//  CacheError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public enum CacheError<Item: Identifiable>: Error {

    case itemNotFound(withID: Item.ID, itemType: Item.Type)
    case itemsNotFound(itemType: Item.Type)
    
    case summariesNotFound(_ type: String)

}

extension CacheError: Equatable {

    public static func == (lhs: CacheError<Item>, rhs: CacheError<Item>) -> Bool {
        switch (lhs, rhs) {
        case (let .itemNotFound(lhsID, lhsType), let .itemNotFound(rhsID, rhsType)):
            return (lhsID == rhsID && lhsType == rhsType)
        case (let .itemsNotFound(lhsType), let .itemsNotFound(rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
    
}
