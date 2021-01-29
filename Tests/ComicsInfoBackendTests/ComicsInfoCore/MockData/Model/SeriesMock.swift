//
//  SeriesMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum SeriesMock {
    
    static func makeDatabaseItems() -> [String: Data] {
        let series = makeSeries()
        return [series.itemID: try! JSONEncoder().encode(series)]
    }

    static func makeSeries(
        id: String = "1",
        popularity: Int = 0,
        title: String = "Series Title",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        startYear: Int? = nil,
        endYear: Int? = nil,
        aliases: [String]? = nil,
        nextIdentifier: String? = nil,
        charactersID: Set<String>? = nil,
        characters: [CharacterSummary<Series>]? = nil,
        comicsID: Set<String>? = nil,
        comics: [ComicSummary<Series>]? = nil
    ) -> Series {
        Series(
            id: id,
            popularity: popularity,
            title: title,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            startYear: startYear,
            endYear: endYear,
            aliases: aliases,
            nextIdentifier: nextIdentifier,
            charactersID: charactersID,
            characters: characters,
            comicsID: comicsID,
            comics: comics,
            itemID: "Series#\(id)",
            summaryID: "Sseries#\(id)",
            itemName: "Series"
        )
    }

    static var requestBody: String {
        "{ \"identifier\": \"1\", \"title\": \"Title\", \"popularity\": 0 }"
    }

    static var series: Series {
        Series(
            id: "1",
            popularity: 0,
            title: "Series Title",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Series Thumbnail",
            description: "Series Description",
            startYear: Int.min,
            endYear: Int.max,
            aliases: ["Series Aliases"],
            nextIdentifier: "2",
            charactersID: ["1"],
            characters: CharacterSummaryMock.characterSummaryList(),
            comicsID: ["1"],
            comics: ComicSummaryMock.comicSummaryList(),
            itemID: "Series#1",
            summaryID: "Series#1",
            itemName: "Series"
        )
    }
    
    static func makeDatabaseItemsList() -> [String: Data] {
        var items = [String: Data]()
        for series in seriesList {
            items[series.itemID] = try! JSONEncoder().encode(series)
        }
        return items
    }

    static var seriesList: [Series] {
        [
            Series(
                id: "2",
                popularity: 2,
                title: "Series Title 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 2",
                description: "Series Description 2",
                startYear: nil,
                endYear: nil,
                aliases: nil,
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Series#2",
                summaryID: "Series#2",
                itemName: "Series"
            ),
            Series(
                id: "3",
                popularity: 3,
                title: "Series Title 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 3",
                description: "Series Description 3",
                startYear: nil,
                endYear: nil,
                aliases: nil,
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Series#3",
                summaryID: "Series#3",
                itemName: "Series"
            ),
            Series(
                id: "4",
                popularity: 4,
                title: "Series Title 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Series Thumbnail 4",
                description: "Series Description 4",
                startYear: nil,
                endYear: nil,
                aliases: nil,
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Series#4",
                summaryID: "Series#4",
                itemName: "Series"
            )
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "Series#1",
            "summaryID": "Series#1",
            "itemName": "Series",
            "summaryName": "Series",
            "popularity": 0,
            "title": "Series Title",
            "dateAdded": "14 January 2021 23:27:03",
            "dateLastUpdated": "14 January 2021 23:27:03",
            "thumbnail": "Series Thumbnail",
            "description": "Series Description"
        ]
    }

}
