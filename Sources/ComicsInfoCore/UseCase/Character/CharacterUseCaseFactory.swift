//
//  CharacterUseCaseFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct CharacterUseCaseFactory<CacheProvider: Cacheable> where CacheProvider.Item == Character  {

    let eventLoop: EventLoop
    let isLocalServer: Bool
    let cacheProvider: CacheProvider

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
    }

    public func makeUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, CacheProvider> {
        CharacterUseCase(characterRepository: makeCharacterRepository())
    }

    private func makeCharacterRepository() -> Repository<CharacterRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> CharacterRepositoryAPIWrapper {
        CharacterRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService()
        )
    }

    private func makeRepositoryAPIService() -> RepositoryAPIService {
        DatabaseProvider(database: makeDatabase(), tableName: .characterTableName)
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop)
    }

}
