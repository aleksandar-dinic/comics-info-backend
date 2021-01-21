//
//  DatabaseItemSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol DatabaseItemSummary: DatabaseDecodable {

    associatedtype Item: SummaryMapper
    
    var summaryName: String { get }

    init(_ item: Item, id: String, itemName: String)

    mutating func update(with item: Item)
    func shouldBeUpdated(with item: Item) -> Bool

}

extension DatabaseItemSummary {
    
    var notUpdatableFields: Set<String> {
        ["itemID", "summaryID"]
    }
    
}
