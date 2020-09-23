//
//  CharacterDataProviderMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import Foundation
import NIO

struct CharacterDataProviderMockFactory: CharacterDataProviderFactory {

    let eventLoop: EventLoop
    var characterCacheService: CharacterCacheService
    var characterAPIService: CharacterAPIService
    var characterDecoderService: CharacterDecoderService
    var characterAPIWrapperMockFactory: CharacterAPIWrapperMockFactory

    init(
        on eventLoop: EventLoop,
        characterCacheService: CharacterCacheService = CharacterCacheServiceMock(),
        characterAPIService: CharacterAPIService = CharacterAPIServiceMock(),
        characterDecoderService: CharacterDecoderService = CharacterDecoderMock()
    ) {
        self.eventLoop = eventLoop
        self.characterCacheService = characterCacheService
        self.characterAPIService = characterAPIService
        self.characterDecoderService = characterDecoderService
        self.characterAPIWrapperMockFactory = CharacterAPIWrapperMockFactory(on: eventLoop)
    }

    mutating func makeWithCharactersFromDatabase() -> CharacterDataProvider {
        _ = characterAPIWrapperMockFactory.makeWithCharacters()
        characterAPIService = characterAPIWrapperMockFactory.characterAPIService
        characterDecoderService = characterAPIWrapperMockFactory.characterDecoderService

        return makeCharacterDataProvider()
    }

    mutating func makeWithCharactersFromMemory() -> CharacterDataProvider {
        _ = characterAPIWrapperMockFactory.makeWithoutData()
        (characterCacheService as? CharacterCacheServiceMock)?.setCharacters(CharactersMock.characters)

        return makeCharacterDataProvider()
    }

    mutating func makeWithoutData() -> CharacterDataProvider {
        _ = characterAPIWrapperMockFactory.makeWithoutData()
        characterCacheService = CharacterCacheServiceMock()

        return makeCharacterDataProvider()
    }

    mutating func makeWithCharacterFromDatabase() -> CharacterDataProvider {
        _ = characterAPIWrapperMockFactory.makeWithCharacter()
        characterAPIService = characterAPIWrapperMockFactory.characterAPIService
        characterDecoderService = characterAPIWrapperMockFactory.characterDecoderService

        return makeCharacterDataProvider()
    }

    mutating func makeWithCharacterFromMemory() -> CharacterDataProvider {
        _ = characterAPIWrapperMockFactory.makeWithoutData()
        (characterCacheService as? CharacterCacheServiceMock)?.setCharacter(CharactersMock.character)

        return makeCharacterDataProvider()
    }

}
