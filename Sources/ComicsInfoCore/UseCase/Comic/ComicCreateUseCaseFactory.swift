//
//  ComicCreateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicCreateUseCaseFactory: CreateUseCaseFactory, CharacterUseCaseBuilder, SeriesUseCaseBuilder {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool
    public let logger: Logger

    public init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        logger: Logger
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.logger = logger
    }

    public func makeUseCase() -> ComicCreateUseCase<ComicCreateRepositoryAPIWrapper> {
        ComicCreateUseCase(
            repository: makecomicRepository(),
            characterUseCase: buildCharacterUseCase(),
            seriesUseCase: buildSeriesUseCase()
        )
    }

    private func makecomicRepository() -> CreateRepository<ComicCreateRepositoryAPIWrapper> {
        CreateRepositoryFactory(repositoryAPIWrapper: makeRepositoryAPIWrapper())
            .makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicCreateRepositoryAPIWrapper {
        ComicCreateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

}
