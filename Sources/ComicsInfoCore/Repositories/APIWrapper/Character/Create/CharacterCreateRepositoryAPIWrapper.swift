//
//  CharacterCreateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct CharacterCreateRepositoryAPIWrapper: CreateRepositoryAPIWrapper {

    public let eventLoop: EventLoop
    public let repositoryAPIService: CreateRepositoryAPIService
    public let logger: Logger
    public let encoderService: EncoderService

    public init(
        on eventLoop: EventLoop,
        repositoryAPIService: CreateRepositoryAPIService,
        logger: Logger,
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.logger = logger
        self.encoderService = encoderService
    }

    public func create(_ item: Character, in table: String) -> EventLoopFuture<Void> {
        CharacterCreateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            seriesUseCase: makeSeriesUseCase(),
            comicUseCase: makeComicUseCase()
        ).create(item, in: table)
    }
    
    private func makeSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    private func makeComicUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

}
