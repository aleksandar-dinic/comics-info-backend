//
//  CharacterMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum CharacterMock {

    static func makeDatabaseItems() -> [String: Data] {
        let character = makeCharacter()
        return [character.itemID: try! JSONEncoder().encode(character)]
    }
    
    static func makeCharacter(
        id: String = "1",
        popularity: Int = 0,
        name: String = "Character Name",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        realName: String? = nil,
        aliases: [String]? = nil,
        birth: Date? = nil,
        seriesID: Set<String>? = nil,
        series: [SeriesSummary<Character>]? = nil,
        comicsID: Set<String>? = nil,
        comics: [ComicSummary<Character>]? = nil
    ) -> Character {
        Character(
            id: id,
            popularity: popularity,
            name: name,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            realName: realName,
            aliases: aliases,
            birth: birth,
            seriesID: seriesID,
            series: series,
            comicsID: comicsID,
            comics: comics,
            itemID: "Character#\(id)",
            summaryID: "Character#\(id)",
            itemName: "Character"
        )
    }

    static var requestBody: String {
        "{ \"identifier\": \"1\", \"name\": \"Name\", \"popularity\": 0 }"
    }

    static var character: Character {
        Character(
            id: "1",
            popularity: 0,
            name: "Character Name",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Character Thumbnail",
            description: "Character Description",
            realName: "Character Real Name",
            aliases: ["Character Aliases"],
            birth: Date(),
            seriesID: ["1"],
            series: SeriesSummaryMock.seriesSummaryList(),
            comicsID: ["1"],
            comics: ComicSummaryMock.comicSummaryList(),
            itemID: "Character#1",
            summaryID: "Character#1",
            itemName: "Character"
        )
    }
    
    static func makeDatabaseItemsList() -> [String: Data] {
        var items = [String: Data]()
        for character in charactersList {
            items[character.itemID] = try! JSONEncoder().encode(character)
        }
        return items
    }

    static var charactersList: [Character] {
        [
            Character(
                id: "2",
                popularity: 2,
                name: "Character Name 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 2",
                description: "Character Description 2",
                realName: nil,
                aliases: nil,
                birth: nil,
                seriesID: nil,
                series: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Character#2",
                summaryID: "Character#2",
                itemName: "Character"
            ),
            Character(
                id: "3",
                popularity: 3,
                name: "Character Name 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 3",
                description: "Character Description 3",
                realName: nil,
                aliases: nil,
                birth: nil,
                seriesID: nil,
                series: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Character#3",
                summaryID: "Character#3",
                itemName: "Character"
            ),
            Character(
                id: "4",
                popularity: 4,
                name: "Character Name 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 4",
                description: "Character Description 4",
                realName: nil,
                aliases: nil,
                birth: nil,
                seriesID: nil,
                series: nil,
                comicsID: nil,
                comics: nil,
                itemID: "Character#4",
                summaryID: "Character#4",
                itemName: "Character"
            )
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "Character#1",
            "summaryID": "Character#1",
            "itemName": "Character",
            "summaryName": "Character",
            "popularity": 0,
            "name": "Character Name",
            "dateAdded": "14 January 2021 23:27:03",
            "dateLastUpdated": "14 January 2021 23:27:03",
            "thumbnail": "Character Thumbnail",
            "description": "Character Description",
            "realName": "Character Real Name",
            "aliases": ["Character aliases"],
            "birth": "14 January 2021 23:27:03",
        ]
    }

}
