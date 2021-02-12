//
//  MockItemSummary.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 31/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct MockItemSummary: ItemSummary {

    let itemID: String
    let summaryID: String
    let itemType: String
    let dateAdded: Date
    let dateLastUpdated: Date
    let popularity: Int
    let name: String
    let thumbnail: String?
    let description: String?
    
}

enum MockItemSummaryFactory {
    
    static func make(
        itemID: String = "MockItemSummary#1",
        summaryID: String = "MockItemSummary#1",
        itemType: String = "MockItemSummary",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        popularity: Int = 0,
        name: String = "MockItemSummary Name",
        thumbnail: String? = "Mock Item Summary Thumbnail",
        description: String? = "Mock Item Summary Description"
    ) -> MockItemSummary {
        MockItemSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemType: itemType,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description
        )
    }
    
    static func makeData() -> [String: Data] {
        let summary = make()
        return ["\(summary.itemID)|\(summary.summaryID)": try! JSONEncoder().encode(summary)]
    }
    
}
