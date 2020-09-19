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

    init(on eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    func makeCharacterUseCase() -> CharacterUseCase {
        CharacterUseCase(characterRepository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> CharacterRepository {
        CharacterRepositoryFactory(characterAPIService: makeCharacterAPIService())
            .makeCharacterRepository()
    }

    private func makeCharacterAPIService() -> CharacterAPIService {
        CharacterDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(mocked: CharacterInfo.isLocalServer)
            .makeDatabase(eventLoop: eventLoop)
    }

}
