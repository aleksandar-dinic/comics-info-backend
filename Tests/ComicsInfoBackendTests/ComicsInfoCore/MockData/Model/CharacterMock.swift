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

    static func makeCharacter(
        id: String = "1",
        popularity: Int = 0,
        name: String = "Character Name",
        thumbnail: String? = nil,
        description: String? = nil,
        seriesID: Set<String>? = nil,
        series: [Series]? = nil,
        comicsID: Set<String>? = nil,
        comics: [Comic]? = nil
    ) -> Character {
        Character(
            id: id,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
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
            thumbnail: "Character Thumbnail",
            description: "Character Description",
            seriesID: ["1"],
            series: SeriesMock.seriesList,
            comicsID: ["1"],
            comics: ComicMock.comicList
        )
    }

    static var charactersList: [Character] {
        [
            Character(
                id: "2",
                popularity: 2,
                name: "Character Name 2",
                thumbnail: "Character Thumbnail 2",
                description: "Character Description 2",
                seriesID: nil,
                series: nil,
                comicsID: nil,
                comics: nil
            ),
            Character(
                id: "3",
                popularity: 3,
                name: "Character Name 3",
                thumbnail: "Character Thumbnail 3",
                description: "Character Description 3",
                seriesID: nil,
                series: nil,
                comicsID: nil,
                comics: nil
            ),
            Character(
                id: "4",
                popularity: 4,
                name: "Character Name 4",
                thumbnail: "Character Thumbnail 4",
                description: "Character Description 4",
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
            "thumbnail": "Character Thumbnail",
            "description": "Character Description"
        ]
    }

}
