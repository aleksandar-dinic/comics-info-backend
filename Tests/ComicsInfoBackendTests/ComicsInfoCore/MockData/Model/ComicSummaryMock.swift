//
//  ComicSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Comic
@testable import struct ComicsInfoCore.ItemSummary
import Foundation

enum ComicSummaryMock {

    static func makeComicSummary(
        id: String = "1",
        itemID: String = "comic#1",
        summaryID: String = "comic#1",
        itemName: String = "comic",
        summaryName: String = "comic",
        popularity: Int = 0,
        title: String = "ComicSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> ItemSummary<Comic> {
        ItemSummary(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            summaryName: summaryName,
            popularity: popularity,
            name: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            count: count,
            number: number,
            roles: roles
        )
    }

    static var comicSummary: ItemSummary<Comic> {
        ItemSummary(
            id: "1",
            itemID: "comic#1",
            summaryID: "comic#1",
            itemName: "comic",
            summaryName: "comic",
            popularity: 0,
            name: "ComicSummary 1 Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "ComicSummary 1 Thumbnail",
            description: "ComicSummary 1 Description",
            count: 1,
            number: "1",
            roles: ["Comic role"]
        )
    }
    
    static var comicSummaryList: [ItemSummary<Comic>] {
        [
            ItemSummary(
                id: "2",
                itemID: "comic#2",
                summaryID: "comic#2",
                itemName: "comic",
                summaryName: "comic",
                popularity: 2,
                name: "Comic Title 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 2",
                description: "Comic Description 2",
                count: 1,
                number: "2",
                roles: ["Comic role"]
            ),
            ItemSummary(
                id: "3",
                itemID: "comic#3",
                summaryID: "comic#3",
                itemName: "comic",
                summaryName: "comic",
                popularity: 3,
                name: "Comic Title 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 3",
                description: "Comic Description 3",
                count: 1,
                number: "3",
                roles: ["Comic role"]
            ),
            ItemSummary(
                id: "4",
                itemID: "comic#4",
                summaryID: "comic#4",
                itemName: "comic",
                summaryName: "comic",
                popularity: 4,
                name: "Comic Title 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Comic Thumbnail 4",
                description: "Comic Description",
                count: 1,
                number: "4",
                roles: ["Comic role"]
            )
        ]
    }

}
