//
//  SeriesFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 12/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum SeriesFactory {
    
    static var requestBody: String {
        "{ \"identifier\": \"1\", \"title\": \"Series Title\", \"popularity\": 0 }"
    }
    
    static func makeDatabaseItems() -> [String: Data] {
        let series = make()
        return [series.itemID: try! JSONEncoder().encode(series)]
    }
    
    static func makeDatabaseItemsList() -> [String: Data] {
        var items = [String: Data]()
        for series in seriesList {
            items[series.itemID] = try! JSONEncoder().encode(series)
        }
        return items
    }
    
    static func make(ID: String = "1", popularity: Int = 0) -> Series {
        make(
            id: ID,
            popularity: popularity,
            title: "Series Title \(ID)",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Series Thumbnail \(ID)",
            description: "Series Description \(ID)",
            startYear: Int.min,
            endYear: Int.max,
            aliases: ["Series Aliases \(ID)"],
            nextIdentifier: "2",
            charactersID: nil,
            characters: nil,
            comicsID: nil,
            comics: nil
        )
    }

    static func make(
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
        characters: [CharacterSummary]? = nil,
        comicsID: Set<String>? = nil,
        comics: [ComicSummary]? = nil
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

    static var seriesList: [Series] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
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
