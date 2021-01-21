//
//  SeriesSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Series
@testable import struct ComicsInfoCore.ItemSummary
import Foundation

enum SeriesSummaryMock {

    static func makeSeriesSummary(
        id: String = "1",
        itemID: String = "series#1",
        summaryID: String = "series#1",
        itemName: String = "series",
        summaryName: String = "series",
        popularity: Int = 0,
        title: String = "SeriesSummary 1 Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> ItemSummary<Series> {
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

    static var seriesSummary: ItemSummary<Series> {
        ItemSummary(
            id: "1",
            itemID: "series#1",
            summaryID: "series#1",
            itemName: "series",
            summaryName: "series",
            popularity: 0,
            name: "SeriesSummary 1 Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "SeriesSummary 1 Thumbnail",
            description: "SeriesSummary 1 Description",
            count: 1,
            number: "1",
            roles: ["Series role"]
        )
    }
    
    static var seriesSummaryList: [ItemSummary<Series>] {
        [
            ItemSummary(
                id: "2",
                itemID: "series#2",
                summaryID: "series#2",
                itemName: "series",
                summaryName: "series",
                popularity: 2,
                name: "Series Title 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 2",
                description: "Series Description 2",
                count: 2,
                number: "2",
                roles: ["Series role"]
            ),
            ItemSummary(
                id: "3",
                itemID: "series#3",
                summaryID: "series#3",
                itemName: "series",
                summaryName: "series",
                popularity: 3,
                name: "Series Title 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 3",
                description: "Series Description 3",
                count: 3,
                number: "3",
                roles: ["Series role"]
            ),
            ItemSummary(
                id: "4",
                itemID: "series#4",
                summaryID: "series#4",
                itemName: "series",
                summaryName: "series",
                popularity: 4,
                name: "Series Title 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 4",
                description: "Series Description 4",
                count: 4,
                number: "4",
                roles: ["Series role"]
            )
        ]
    }
    
}
