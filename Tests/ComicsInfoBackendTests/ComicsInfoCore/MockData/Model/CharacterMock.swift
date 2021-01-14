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

    static func makeDatabasePutItem(_ table: String) -> DatabasePutItem {
        let character = makeCharacter()
        let characterDatabase = CharacterDatabase(item: character)
        let encoder = EncoderProvider()
        return encoder.encode(characterDatabase, table: table)
    }
    
    static func makeDatabaseItems(_ table: String) -> [String: TableMock] {
        let item = makeDatabasePutItem(table)

        guard
            let itemID = item["itemID"] as? String,
            let summaryID = item["summaryID"] as? String
        else { return [:] }

        let id = "\(itemID)|\(summaryID)"
        return [id: TableMock(id: id, attributesValue: item.attributeValues)]
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
        series: [Series]? = nil,
        comicsID: Set<String>? = nil,
        comics: [Comic]? = nil
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
            comics: comics
        )
    }

    static var requestBody: String {
        "{ \"id\": \"1\", \"name\": \"Name\", \"popularity\": 0 }"
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
            series: SeriesMock.seriesList,
            comicsID: ["1"],
            comics: ComicMock.comicList
        )
    }
    
    static func makeDatabasePutItemsList(_ table: String) -> [DatabasePutItem] {
        var putItems = [DatabasePutItem]()
        let encoder = EncoderProvider()
        for character in charactersList {
            let character = CharacterDatabase(item: character)
            putItems.append(encoder.encode(character, table: table))
        }
        
        return putItems
    }
    
    static func makeDatabaseItemsList(_ table: String) -> [String: TableMock] {
        let putItems = makeDatabasePutItemsList(table)
        var items = [String: TableMock]()
        for item in putItems {
            guard
                let itemID = item["itemID"] as? String,
                let summaryID = item["summaryID"] as? String
            else { continue }

            let id = "\(itemID)|\(summaryID)"
            items[id] = TableMock(id: id, attributesValue: item.attributeValues)
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
                comics: nil
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
                comics: nil
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
                comics: nil
            )
        ]
    }

    static var items: [String: Any] {
        [
            "itemID": "character#1",
            "summaryID": "character#1",
            "itemName": "character",
            "popularity": 0,
            "name": "Character Name",
            "dateAdded": "January 01, 2000",
            "dateLastUpdated": "January 01, 2020",
            "thumbnail": "Character Thumbnail",
            "description": "Character Description",
            "realName": "Character Real Name",
            "aliases": ["Character aliases"],
            "birth": "January 28, 1977",
        ]
    }

}
