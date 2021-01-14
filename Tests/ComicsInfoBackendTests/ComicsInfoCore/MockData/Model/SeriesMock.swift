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
        nextIdentifier: String? = nil,
        charactersID: Set<String>? = nil,
        characters: [Character]? = nil,
        comicsID: Set<String>? = nil,
        comics: [Comic]? = nil
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
            nextIdentifier: nextIdentifier,
            charactersID: charactersID,
            characters: characters,
            comicsID: comicsID,
            comics: comics
        )
    }

    static var requestBody: String {
        "{ \"id\": \"1\", \"title\": \"Title\", \"popularity\": 0 }"
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
            nextIdentifier: "2",
            charactersID: ["1"],
            characters: CharacterMock.charactersList,
            comicsID: ["1"],
            comics: ComicMock.comicList
        )
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
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil
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
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil
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
                nextIdentifier: nil,
                charactersID: nil,
                characters: nil,
                comicsID: nil,
                comics: nil
            )
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "series#1",
            "summaryID": "series#1",
            "itemName": "series",
            "popularity": 0,
            "title": "Series Title",
            "dateAdded": "January 01, 2000",
            "dateLastUpdated": "January 01, 2000",
            "thumbnail": "Series Thumbnail",
            "description": "Series Description"
        ]
    }

}
