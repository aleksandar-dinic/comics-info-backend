//
//  CharacterSummaryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.CharacterSummary
import Foundation

enum CharacterSummaryMock {

    static func makeCharacterSummary(
        itemID: String = "character#1",
        summaryID: String = "character#1",
        itemName: String = "character",
        summaryName: String = "character",
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = nil,
        description: String? = nil
    ) -> CharacterSummary {
        CharacterSummary(
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            summaryName: summaryName,
            popularity: popularity,
            name: name,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var characterSummary: CharacterSummary {
        CharacterSummary(
            itemID: "character#1",
            summaryID: "character#1",
            itemName: "character",
            summaryName: "character",
            popularity: 0,
            name: "CharacterSummary 1 Name",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            thumbnail: "CharacterSummary 1 Thumbnail",
            description: "CharacterSummary 1 Description"
        )
    }

}
