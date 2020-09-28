//
//  CharacterUseCaseFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct CharacterUseCaseFactory {

    private let eventLoop: EventLoop
    private let isLocalServer: Bool
    private let characterCacheService: CharacterCacheService

    init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        characterCacheService: CharacterCacheService = CharacterInfo.characterCacheProvider
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.characterCacheService = characterCacheService
    }

    func makeCharacterUseCase() -> CharacterUseCase {
        CharacterUseCase(characterRepository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> CharacterRepository {
        CharacterRepositoryFactory(
            characterAPIService: makeCharacterAPIService(),
            characterCacheService: characterCacheService
        ).makeCharacterRepository()
    }

    private func makeCharacterAPIService() -> CharacterAPIService {
        CharacterDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop)
    }

}
