//
//  CharacterRepositoryMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import Foundation
import NIO

struct CharacterRepositoryMockFactory {

    var characterDataProviderMockFactory: CharacterDataProviderMockFactory

    init(on eventLoop: EventLoop) {
        characterDataProviderMockFactory = CharacterDataProviderMockFactory(on: eventLoop)
    }

    mutating func makeWithCharacters() -> CharacterRepository {
        let characterDataProvider = characterDataProviderMockFactory.makeWithCharactersFromMemory()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

    mutating func makeWithCharacter() -> CharacterRepository {
        let characterDataProvider = characterDataProviderMockFactory.makeWithCharacterFromMemory()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

    mutating func makeWithoutData() -> CharacterRepository {
        let characterDataProvider = characterDataProviderMockFactory.makeWithoutData()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

}
