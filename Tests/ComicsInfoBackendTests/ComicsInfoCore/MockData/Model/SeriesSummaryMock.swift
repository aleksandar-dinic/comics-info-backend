//
//  SeriesSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct ComicsInfoCore.SeriesSummary
import Foundation

enum SeriesSummaryMock {

    static func makeSeriesSummary<Item>(
        id: String = "1",
        itemID: String = "Series#1",
        summaryID: String = "Series#1",
        itemName: String = "Series",
        popularity: Int = 0,
        title: String = "SeriesSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> SeriesSummary<Item> {
        SeriesSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: title,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var seriesSummary: SeriesSummary<Character> {
        SeriesSummary(
            itemID: "Series#1",
            summaryID: "Series#1",
            itemName: "Series",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: 0,
            name: "SeriesSummary 1 Title",
            thumbnail: "SeriesSummary 1 Thumbnail",
            description: "SeriesSummary 1 Description"
        )
    }
    
    static func seriesSummaryList<Item>() -> [SeriesSummary<Item>] {
        [
            SeriesSummary(
                itemID: "Series#2",
                summaryID: "Series#2",
                itemName: "Series",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 2,
                name: "Series Title 2",
                thumbnail: "Series Thumbnail 2",
                description: "Series Description 2"
            ),
            SeriesSummary(
                itemID: "Series#3",
                summaryID: "Series#3",
                itemName: "Series",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 3,
                name: "Series Title 3",
                thumbnail: "Series Thumbnail 3",
                description: "Series Description 3"
            ),
            SeriesSummary(
                itemID: "Series#4",
                summaryID: "Series#4",
                itemName: "Series",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 4,
                name: "Series Title 4",
                thumbnail: "Series Thumbnail 4",
                description: "Series Description 4"
            )
        ]
    }
    
}
