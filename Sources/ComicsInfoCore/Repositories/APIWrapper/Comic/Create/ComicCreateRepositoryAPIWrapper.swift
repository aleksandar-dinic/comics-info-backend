//
//  ComicCreateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicCreateRepositoryAPIWrapper: CreateRepositoryAPIWrapper {

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

    public func create(_ item: Comic, in table: String) -> EventLoopFuture<Void> {
        ComicCreateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            characterUseCase: makeCharacterUseCase(),
            seriesUseCase: makeSeriesUseCase()
        ).create(item, in: table)
    }
    
    private func makeCharacterUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

    private func makeSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
    }

}
