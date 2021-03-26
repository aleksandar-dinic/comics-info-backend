//
//  MockComicInfoItem.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct MockComicInfoItem: ComicInfoItem {

    let id: String
    let itemID: String
    let summaryID: String
    let itemType: String
    
    private(set) var sortValue: String
    private(set) var popularity: Int
    private(set) var name: String
    
    private(set) var dummyField: String?
    
    mutating func update(with newItem: MockComicInfoItem) {
        popularity = newItem.popularity
        name = newItem.name
        
        if let dummyField = newItem.dummyField {
            self.dummyField = dummyField
        }
        sortValue = "\(summaryID)#Popularity=\(popularity)#Name=\(name)"
    }
    
}

enum MockComicInfoItemFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> MockComicInfoItem {
        make(
            id: ID,
            itemID: "MockComicInfoItem#\(ID)",
            summaryID: "MockComicInfoItem#\(ID)",
            popularity: popularity,
            name: "MockComicInfoItem name \(ID)"
        )
    }
    
    static func make(
        id: String = "1",
        itemID: String = "MockComicInfoItem#1",
        summaryID: String = "MockComicInfoItem#1",
        itemType: String = "MockComicInfoItem",
        popularity: Int = 0,
        name: String = "MockComicInfoItem name 1",
        dummyField: String? = nil
    ) -> MockComicInfoItem {
        MockComicInfoItem(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemType: itemType,
            sortValue: "\(summaryID)#Popularity=\(popularity)#Name=\(name)",
            popularity: popularity,
            name: name,
            dummyField: dummyField
        )
    }
    
    static func makeData() -> [String: Data] {
        let item = make()
        return [item.itemID: try! JSONEncoder().encode(item)]
    }
    
}
