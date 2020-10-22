//
//  SeriesUseCaseFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesUseCaseFactory<CacheProvider: Cacheable>: UseCaseFactory where CacheProvider.Item == Series {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let cacheProvider: CacheProvider
    public let logger: Logger
    public let tableName: String

    private let characterTableName: String
    private let comicTableName: String

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        cacheProvider: CacheProvider,
        logger: Logger,
        tableName: String = .seriesTableName,
        characterTableName: String = .characterTableName,
        comicTableName: String = .comicTableName
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.cacheProvider = cacheProvider
        self.logger = logger
        self.tableName = tableName
        self.characterTableName = characterTableName
        self.comicTableName = comicTableName
    }

    public func makeUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, CacheProvider> {
        SeriesUseCase(repository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> Repository<SeriesRepositoryAPIWrapper, CacheProvider> {
        RepositoryFactory(
            on: eventLoop,
            repositoryAPIWrapper: makeRepositoryAPIWrapper(),
            cacheProvider: cacheProvider
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesRepositoryAPIWrapper {
        SeriesRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger,
            tableName: tableName,
            characterTableName: characterTableName,
            comicTableName: comicTableName
        )
    }

}
