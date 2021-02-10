//
//  CharacterSummaryFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.CharacterSummary
import Foundation

enum CharacterSummaryFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> CharacterSummary {
        make(
            itemID: "Character#\(ID)",
            summaryID: "Character#\(ID)",
            itemName: "Character",
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: popularity,
            name: "CharacterSummary \(ID) Name",
            thumbnail: "CharacterSummary \(ID) Thumbnail",
            description: "CharacterSummary \(ID) Description",
            count: 1
        )
    }

    static func make(
        itemID: String = "Character#1",
        summaryID: String = "Character#1",
        itemName: String = "Character",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        thumbnail: String? = "CharacterSummary 1 Thumbnail",
        description: String? = "CharacterSummary 1 Description",
        count: Int? = 1
    ) -> CharacterSummary {
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

    static func makeList() -> [CharacterSummary] {
        [
            make(ID: "2", popularity: 2),
            make(ID: "3", popularity: 3),
            make(ID: "4", popularity: 4)
        ]
    }
    
}
