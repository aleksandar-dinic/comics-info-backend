//
//  GetCharacters.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 13/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.CharacterSummary
@testable import struct ComicsInfoCore.Character
import Foundation

enum CharacterSummaryFactory {
    
    static func make(ID: String = "1", popularity: Int = 0) -> CharacterSummary {
        make(
            ID: ID,
            link: CharacterFactory.make(ID: "9"),
            popularity: popularity,
            name: "CharacterSummary \(ID) Name",
            thumbnail: "CharacterSummary \(ID) Thumbnail",
            description: "CharacterSummary \(ID) Description",
            count: 1
        )
    }

    static func make(
        ID: String = "1",
        link: Character = CharacterFactory.make(ID: "9"),
        popularity: Int = 0,
        name: String = "CharacterSummary 1 Name",
        thumbnail: String? = "CharacterSummary 1 Thumbnail",
        description: String? = "CharacterSummary 1 Description",
        count: Int? = 1
    ) -> CharacterSummary {
        CharacterSummary(
            ID: ID,
            link: link,
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
