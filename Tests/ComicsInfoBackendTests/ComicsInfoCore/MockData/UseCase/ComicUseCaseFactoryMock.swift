//
//  ComicUseCaseFactoryMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 17/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct ComicUseCaseFactoryMock: UseCaseFactory {

    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool
    var cacheProvider: InMemoryCacheProvider<Comic>
    var tableName: String
    let characterTableName: String
    let seriesTableName: String

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "ComicUseCaseFactoryMock")
        isLocalServer = true
        cacheProvider = InMemoryCacheProvider<Comic>()
        tableName = "comic"
        characterTableName = "character"
        seriesTableName = "series"
    }

    func makeUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
        ComicUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> Repository<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
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
