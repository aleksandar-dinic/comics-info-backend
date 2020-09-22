//
//  CharacterAPIWrapperMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import CharacterInfo
import Foundation
import NIO

struct CharacterAPIWrapperMockFactory: CharacterAPIWrapperFactory {

    let eventLoop: EventLoop
    var characterAPIService: CharacterAPIService
    var characterDecoderService: CharacterDecoderService

    init(
        on eventLoop: EventLoop,
        characterAPIService: CharacterAPIService = CharacterAPIServiceMock(),
        characterDecoderService: CharacterDecoderService = CharacterDecoderMock()
    ) {
        self.eventLoop = eventLoop
        self.characterAPIService = characterAPIService
        self.characterDecoderService = characterDecoderService
    }

    mutating func makeWithCharacters() -> CharacterAPIWrapper {
        characterAPIService = CharacterAPIServiceMock(on: eventLoop, items: CharactersMock.charactersItems)
        characterDecoderService = CharacterDecoderMock(CharactersMock.characters)

        return makeCharacterAPIWrapper()
    }

    mutating func makeWithoutData() -> CharacterAPIWrapper {
        characterAPIService = CharacterAPIServiceMock(on: eventLoop)
        characterDecoderService = CharacterDecoderMock()

        return makeCharacterAPIWrapper()
    }

    mutating func makeWithCharactersBadData() -> CharacterAPIWrapper {
        characterAPIService = CharacterAPIServiceMock(on: eventLoop, items: CharactersMock.charactersBadData)
        characterDecoderService = CharacterDecoderMock()

        return makeCharacterAPIWrapper()
    }

    mutating func makeWithCharacter() -> CharacterAPIWrapper {
        characterAPIService = CharacterAPIServiceMock(on: eventLoop, items: [CharactersMock.characterData])
        characterDecoderService = CharacterDecoderMock([CharactersMock.character])

        return makeCharacterAPIWrapper()
    }

    mutating func makeWithCharacterBadData() -> CharacterAPIWrapper {
        characterAPIService = CharacterAPIServiceMock(on: eventLoop, items: [CharactersMock.characterBadData])
        characterDecoderService = CharacterDecoderMock()

        return makeCharacterAPIWrapper()
    }

}
