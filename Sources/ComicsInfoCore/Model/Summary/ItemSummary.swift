//
//  ItemSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol ItemSummary: Codable, Comparable {
    
    var itemID: String { get }
    var sortValue: String { get }
    var summaryID: String { get }
    var itemType: String { get }
    var summaryType: String { get }
    
    var dateAdded: Date { get }
    var dateLastUpdated: Date { get }
    var popularity: Int { get }
    var name: String { get }
    var thumbnail: String? { get }
    var description: String? { get }
    var oldSortValue: String? { get }
    
}

public extension ItemSummary {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.sortValue < rhs.sortValue
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.itemID == rhs.itemID
    }
    
}
