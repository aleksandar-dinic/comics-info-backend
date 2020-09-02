//
//  CharacterAPIWrapperMockFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct CharacterAPIWrapperMockFactory {

    static func makeWithCharacters() -> CharacterAPIWrapper {
        let characterAPIServiceMock = CharacterAPIServiceMock(CharactersMock.charactersItems)
        let characterDecoderService = CharacterDecoderMock(CharactersMock.characters)

        return CharacterAPIWrapper(
            characterAPIService: characterAPIServiceMock,
            characterDecoderService: characterDecoderService
        )
    }

    static func makeWithoutData() -> CharacterAPIWrapper {
        let characterAPIServiceMock = CharacterAPIServiceMock()
        let characterDecoderService = CharacterDecoderMock()

        return CharacterAPIWrapper(
            characterAPIService: characterAPIServiceMock,
            characterDecoderService: characterDecoderService
        )
    }

    static func makeWithCharactersBadData() -> CharacterAPIWrapper {
        let characterAPIServiceMock = CharacterAPIServiceMock(CharactersMock.charactersBadData)
        let characterDecoderService = CharacterDecoderMock()

        return CharacterAPIWrapper(
            characterAPIService: characterAPIServiceMock,
            characterDecoderService: characterDecoderService
        )
    }

    static func makeWithCharacter() -> CharacterAPIWrapper {
        let characterAPIServiceMock = CharacterAPIServiceMock([CharactersMock.characterData])
        let characterDecoderService = CharacterDecoderMock([CharactersMock.character])

        return CharacterAPIWrapper(
            characterAPIService: characterAPIServiceMock,
            characterDecoderService: characterDecoderService
        )
    }

    static func makeWithCharacterBadData() -> CharacterAPIWrapper {
        let characterAPIServiceMock = CharacterAPIServiceMock([CharactersMock.characterBadData])
        let characterDecoderService = CharacterDecoderMock()

        return CharacterAPIWrapper(
            characterAPIService: characterAPIServiceMock,
            characterDecoderService: characterDecoderService
        )
    }

}
