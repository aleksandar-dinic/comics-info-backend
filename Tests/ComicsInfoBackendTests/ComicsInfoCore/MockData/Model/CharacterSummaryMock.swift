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
        tableName: String = "character",
        itemID: String = "character#1",
        summaryID: String = "character#1",
        itemName: String = "character",
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        thumbnail: String? = nil,
        description: String? = nil
    ) -> CharacterSummary {
        CharacterSummary(
            tableName: tableName,
            itemID: itemID,
            summaryID: summaryID,
            itemName: itemName,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description
        )
    }

    static var characterSummary: CharacterSummary {
        CharacterSummary(
            tableName: "character",
            itemID: "character#1",
            summaryID: "character#1",
            itemName: "character",
            popularity: 0,
            name: "CharacterSummary 1 Name",
            thumbnail: "CharacterSummary 1 Thumbnail",
            description: "CharacterSummary 1 Description"
        )
    }

}
