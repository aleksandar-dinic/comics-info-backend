//
//  ComicSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct ComicsInfoCore.ComicSummary
import Foundation

enum ComicSummaryMock {

    static func makeComicSummary<Item>(
        id: String = "1",
        itemID: String = "Comic#1",
        summaryID: String = "Comic#1",
        itemName: String = "Comic",
        popularity: Int = 0,
        title: String = "ComicSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> ComicSummary<Item> {
        ComicSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: title,
            thumbnail: thumbnail,
            description: description,
            number: number
        )
    }

    static var comicSummary: ComicSummary<Character> {
        ComicSummary(
            itemID: "Comic#1",
            summaryID: "Comic#1",
            itemName: "Comic",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: 0,
            name: "ComicSummary 1 Title",
            thumbnail: "ComicSummary 1 Thumbnail",
            description: "ComicSummary 1 Description",
            number: "1"
        )
    }
    
    static func comicSummaryList<Item>() -> [ComicSummary<Item>] {
        [
            ComicSummary(
                itemID: "Comic#2",
                summaryID: "Comic#2",
                itemName: "Comic",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 2,
                name: "Comic Title 2",
                thumbnail: "Comic Thumbnail 2",
                description: "Comic Description 2",
                number: "2"
            ),
            ComicSummary(
                itemID: "Comic#3",
                summaryID: "Comic#3",
                itemName: "Comic",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 3,
                name: "Comic Title 3",
                thumbnail: "Comic Thumbnail 3",
                description: "Comic Description 3",
                number: "3"
            ),
            ComicSummary(
                itemID: "Comic#4",
                summaryID: "Comic#4",
                itemName: "Comic",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 4,
                name: "Comic Title 4",
                thumbnail: "Comic Thumbnail 4",
                description: "Comic Description",
                number: "4"
            )
        ]
    }

}
