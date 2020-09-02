//
//  CharacterRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterRepositoryFactory: CharacterDataProviderFactory {

    let characterAPIService: CharacterAPIService
    let characterCacheService: CharacterCacheService
    let characterDecoderService: CharacterDecoderService

    init(
        characterAPIService: CharacterAPIService,
        characterCacheService: CharacterCacheService = ComicsInfo.characterCacheProvider,
        characterDecoderService: CharacterDecoderService = CharacterDecoderProvider()
    ) {
        self.characterAPIService = characterAPIService
        self.characterCacheService = characterCacheService
        self.characterDecoderService = characterDecoderService
    }

    func makeCharacterRepository() -> CharacterRepository {
        CharacterRepository(characterDataProvider: makeCharacterDataProvider())
    }

}
