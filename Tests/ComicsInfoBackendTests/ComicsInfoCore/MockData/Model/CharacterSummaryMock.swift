//
//  CharacterSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Series
@testable import struct ComicsInfoCore.CharacterSummary
import Foundation

enum CharacterSummaryMock {

    static func makeCharacterSummary<Item>(
        id: String = "1",
        itemID: String = "Character#1",
        summaryID: String = "Character#1",
        itemName: String = "Character",
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> CharacterSummary<Item> {
        CharacterSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
            count: count
        )
    }

    static var characterSummary: CharacterSummary<Series> {
        CharacterSummary(
            itemID: "Character#1",
            summaryID: "Character#1",
            itemName: "Character",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: 0,
            name: "CharacterSummary 1 Name",
            thumbnail: "CharacterSummary 1 Thumbnail",
            description: "CharacterSummary 1 Description",
            count: 1
        )
    }
    
    static func characterSummaryList<Item>() -> [CharacterSummary<Item>] {
        [
            CharacterSummary(
                itemID: "Character#2",
                summaryID: "Character#2",
                itemName: "Character",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 2,
                name: "Character Name 2",
                thumbnail: "Character Thumbnail 2",
                description: "Character Description 2",
                count: 1
            ),
            CharacterSummary(
                itemID: "Character#3",
                summaryID: "Character#3",
                itemName: "Character",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 3,
                name: "Character Name 3",
                thumbnail: "Character Thumbnail 3",
                description: "Character Description 3",
                count: 1
            ),
            CharacterSummary(
                itemID: "Character#4",
                summaryID: "Character#4",
                itemName: "Character",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                popularity: 4,
                name: "Character Name 4",
                thumbnail: "Character Thumbnail 4",
                description: "Character Description 4",
                count: 1
            )
        ]
    }
    
}
