//
//  ComicSummaryFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.ComicSummary
import Foundation

enum ComicSummaryFactory {
    
    static func make<Item>(ID: String = "1", popularity: Int = 0) -> ComicSummary<Item> {
        make(
            itemID: "Comic#\(ID)",
            summaryID: "Comic#\(ID)",
            itemName: "Comic \(ID)",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: 0,
            name: "ComicSummary \(ID) Name",
            thumbnail: "ComicSummary \(ID) Thumbnail",
            description: "ComicSummary \(ID) Description",
            number: "1"
        )
    }

    static func make<Item>(
        itemID: String = "Comic#1",
        summaryID: String = "Comic#1",
        itemName: String = "Comic",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        popularity: Int = 0,
        name: String = "ComicSummary 1 Name",
        thumbnail: String? = nil,
        description: String? = nil,
        number: String? = nil
    ) -> ComicSummary<Item> {
        ComicSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
            number: number
        )
    }
    
    static func comicList<Item>() -> [ComicSummary<Item>] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
        ]
    }

}
