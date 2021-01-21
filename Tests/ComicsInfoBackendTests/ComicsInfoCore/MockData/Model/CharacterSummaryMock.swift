//
//  CharacterSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
@testable import struct ComicsInfoCore.ItemSummary
import Foundation

enum CharacterSummaryMock {

    static func makeCharacterSummary(
        id: String = "1",
        itemID: String = "character#1",
        summaryID: String = "character#1",
        itemName: String = "character",
        summaryName: String = "character",
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil,
        count: Int? = nil,
        number: String? = nil,
        roles: [String]? = nil
    ) -> ItemSummary<Character> {
        ItemSummary(
            id: id,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            summaryName: summaryName,
            popularity: popularity,
            name: name,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            count: count,
            number: number,
            roles: roles
        )
    }

    static var characterSummary: ItemSummary<Character> {
        ItemSummary(
            id: "1",
            itemID: "character#1",
            summaryID: "character#1",
            itemName: "character",
            summaryName: "character",
            popularity: 0,
            name: "CharacterSummary 1 Name",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "CharacterSummary 1 Thumbnail",
            description: "CharacterSummary 1 Description",
            count: 1,
            number: "1",
            roles: ["Character role"]
        )
    }
    
    static var characterSummaryList: [ItemSummary<Character>] {
        [
            ItemSummary(
                id: "2",
                itemID: "character#2",
                summaryID: "character#2",
                itemName: "character",
                summaryName: "character",
                popularity: 2,
                name: "Character Name 2",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 2",
                description: "Character Description 2",
                count: 1,
                number: "2",
                roles: ["Character role"]
            ),
            ItemSummary(
                id: "3",
                itemID: "character#3",
                summaryID: "character#3",
                itemName: "character",
                summaryName: "character",
                popularity: 3,
                name: "Character Name 3",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 3",
                description: "Character Description 3",
                count: 1,
                number: "3",
                roles: ["Character role"]
            ),
            ItemSummary(
                id: "4",
                itemID: "character#4",
                summaryID: "character#4",
                itemName: "character",
                summaryName: "character",
                popularity: 4,
                name: "Character Name 4",
                dateAdded: Date(),
                dateLastUpdated: Date(),
                thumbnail: "Character Thumbnail 4",
                description: "Character Description 4",
                count: 1,
                number: "4",
                roles: ["Character role"]
            )
        ]
    }

}
