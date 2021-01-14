//
//  CharacterUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 08/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct CharacterUseCaseFactoryMock: UseCaseFactory {

    let items: [String: TableMock]
    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool
    var cacheProvider: InMemoryCacheProvider<Character>

    init(items: [String: TableMock], on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.items = items
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "CharacterUseCaseFactoryMock")
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Character>()
    }

    func makeUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCase(repository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> Repository<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> CharacterRepositoryAPIWrapper {
        CharacterRepositoryAPIWrapper(
            repositoryAPIService: makeRepositoryAPIService()
        )
    }
    
    func makeRepositoryAPIService() -> RepositoryAPIService {
        DatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop, logger: logger, items: items)
    }

}
