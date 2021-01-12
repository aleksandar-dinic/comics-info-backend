//
//  SeriesUpdateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesUpdateRepositoryAPIWrapper: UpdateRepositoryAPIWrapper {

    public let eventLoop: EventLoop
    public let repositoryAPIService: UpdateRepositoryAPIService
    public let logger: Logger
    public let decoderService: DecoderService
    public let encoderService: EncoderService

    init(
        on eventLoop: EventLoop,
        repositoryAPIService: UpdateRepositoryAPIService,
        logger: Logger,
        decoderService: DecoderService = DecoderProvider(),
        encoderService: EncoderService = EncoderProvider()
    ) {
        self.eventLoop = eventLoop
        self.repositoryAPIService = repositoryAPIService
        self.logger = logger
        self.decoderService = decoderService
        self.encoderService = encoderService
    }

    public func update(_ item: Series, in table: String) -> EventLoopFuture<Void> {
        SeriesUpdateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: repositoryAPIService,
            encoderService: encoderService,
            decoderService: decoderService,
            characterUseCase: makeCharacterUseCase(),
            comicUseCase: makeComicUseCase()
        ).update(item, in: table)
    }

    private func makeCharacterUseCase() -> CharacterUseCase<CharacterRepositoryAPIWrapper, InMemoryCacheProvider<Character>> {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.characterInMemoryCache,
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
