//
//  ComicUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicUseCaseFactory<CacheProvider: Cacheable>: UseCaseFactory where CacheProvider.Item == Comic  {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: CacheProvider
    public let logger: Logger
    public let tableName: String

    private let characterTableName: String
    private let seriesTableName: String

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider,
        logger: Logger,
        tableName: String = .comicTableName,
        characterTableName: String = .characterTableName,
        seriesTableName: String = .seriesTableName
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
        self.logger = logger
        self.tableName = tableName
        self.characterTableName = characterTableName
        self.seriesTableName = seriesTableName
    }

    public func makeUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, CacheProvider> {
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> Repository<ComicRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicRepositoryAPIWrapper {
        ComicRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger,
            tableName: tableName,
            characterTableName: characterTableName,
            seriesTableName: seriesTableName
        )
    }

}
