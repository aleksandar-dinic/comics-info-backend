//
//  CharacterUseCaseFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterUseCaseFactory<CacheProvider: Cacheable>: UseCaseFactory where CacheProvider.Item == Character  {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: CacheProvider
    public let logger: Logger
    public let tableName: String

    public let seriesTableName: String
    public let comicTableName: String

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider,
        logger: Logger,
        tableName: String = .characterTableName,
        seriesTableName: String = .seriesTableName,
        comicTableName: String = .comicTableName
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
        self.logger = logger
        self.tableName = tableName
        self.seriesTableName = seriesTableName
        self.comicTableName = comicTableName
    }

    public func makeUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, CacheProvider> {
        CharacterUseCase(repository: makeCharacterRepository())
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
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger,
            tableName: tableName,
            seriesTableName: seriesTableName,
            comicTableName: comicTableName
        )
    }
    
}
