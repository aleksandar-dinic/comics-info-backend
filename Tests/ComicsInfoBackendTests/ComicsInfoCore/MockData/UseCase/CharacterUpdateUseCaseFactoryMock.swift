//
//  CharacterUpdateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct CharacterUpdateUseCaseFactoryMock: UpdateUseCaseFactory {

    let items: [String: TableMock]
    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(items: [String: TableMock], on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "CharacterUpdateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> CharacterUpdateUseCase<CharacterUpdateRepositoryAPIWrapper> {
        CharacterUpdateUseCase(repository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> UpdateRepository<CharacterUpdateRepositoryAPIWrapper> {
        UpdateRepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper()
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> CharacterUpdateRepositoryAPIWrapper {
        CharacterUpdateRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger
        )
    }
    
    func makeRepositoryAPIService() -> UpdateRepositoryAPIService {
        UpdateDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> DatabaseUpdate {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabaseUpdate(eventLoop: eventLoop, logger: logger, items: items)
    }

}
