//
//  CharacterFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum CharacterFactory {
    
    static var requestBody: String {
        "{ \"identifier\": \"1\", \"name\": \"Character Name\", \"popularity\": 0 }"
    }

    static func makeDatabaseItems() -> [String: Data] {
        let character = make()
        return [character.itemID: try! JSONEncoder().encode(character)]
    }
    
    static func makeDatabaseItemsList() -> [String: Data] {
        var items = [String: Data]()
        for character in makeList {
            items[character.itemID] = try! JSONEncoder().encode(character)
        }
        return items
    }
    
    static func make(ID: String = "1", popularity: Int = 0) -> Character {
        make(
            id: ID,
            popularity: popularity,
            name: "Character Name \(ID)",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "Character Thumbnail \(ID)",
            description: "Character Description \(ID)",
            realName: "Character \(ID) Real Name",
            aliases: ["Character \(ID) Aliases"],
            birth: Date(),
            seriesID: nil,
            series: nil,
            comicsID: nil,
            comics: nil
        )
    }
    
    static func make(
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
    
    static var makeList: [Character] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
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
