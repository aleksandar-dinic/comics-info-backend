//
//  CharacterRepositoryMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 10/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct CharacterRepositoryMockFactory {

    static func makeWithCharacters() -> CharacterRepository {
        let characterDataProvider = CharacterDataProviderMockFactory.makeWithCharactersFromMemory()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

    static func makeWithCharacter() -> CharacterRepository {
        let characterDataProvider = CharacterDataProviderMockFactory.makeWithCharacterFromMemory()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

    static func makeWithoutData() -> CharacterRepository {
        let characterDataProvider = CharacterDataProviderMockFactory.makeWithoutData()

        return CharacterRepository(characterDataProvider: characterDataProvider)
    }

}
