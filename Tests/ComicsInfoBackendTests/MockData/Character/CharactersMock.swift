//
//  CharactersMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import struct ComicsInfoCore.Character
import Foundation

struct CharactersMock {

    // MARK: - Characters

    static let characters = [
        Character(identifier: "1", popularity: 1, name: "Flash",
                         thumbnail: nil, description: nil),
        Character(identifier: "2", popularity: 2, name: "Batman",
                         thumbnail: nil, description: nil),
        Character(identifier: "3", popularity: 3, name: "Spider-Man",
                         thumbnail: nil, description: nil)
    ]

    static let charactersItems: [[String: Any]] =
        [
            [
                "identifier": "1",
                "popularity": 1,
                "name": "Flash"
            ],[
                "identifier": "2",
                "popularity": 2,
                "name": "Batman"
            ],[
                "identifier": "3",
                "popularity": 3,
                "name": "Spider-Man"
            ]
        ]

    static let charactersBadData: [[String: Any]] =
        [
            [
                "identifier": "1",
                "popularity": 1,
            ],[
                "identifier": "2",
                "popularity": 2,
                "name": "Batman"
            ],[
                "identifier": "3",
                "popularity": 3,
                "name": "Spider-Man"
            ]
        ]

    // MARK: - Character

    static let character = Character(
        identifier: "1",
        popularity: 1,
        name: "Flash",
        thumbnail: nil,
        description: nil
    )

    static let character2 = Character(
        identifier: "2",
        popularity: 1,
        name: "Batman",
        thumbnail: nil,
        description: nil
    )

    static let characterData: [String: Any] =
        [
            "identifier": "1",
            "popularity": 1,
            "name": "Flash"
        ]

    static let characterBadData: [String: Any] =
        [
            "identifier": "1",
            "popularity": 1,
        ]

}
