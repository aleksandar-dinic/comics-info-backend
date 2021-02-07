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
    let itemName: String
    
    let popularity: Int
    let name: String
    
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
        itemName: String = "MockComicInfoItem",
        popularity: Int = 0,
        name: String = "MockComicInfoItem name"
    ) -> MockComicInfoItem {
        MockComicInfoItem(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            popularity: popularity,
            name: name
        )
    }
    
    static func makeData() -> [String: Data] {
        let item = make()
        return [item.itemID: try! JSONEncoder().encode(item)]
    }
    
}
