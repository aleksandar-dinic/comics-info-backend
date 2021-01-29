//
//  ComicUpdateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct ComicUpdateUseCaseFactory: UpdateUseCaseFactory, CharacterUseCaseBuilder, SeriesUseCaseBuilder, ComicUseCaseBuilder {

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

    public func makeUseCase() -> ComicUpdateUseCase<ComicUpdateRepositoryAPIWrapper> {
        ComicUpdateUseCase(
            repository: makecomicRepository(),
            characterUseCase: buildCharacterUseCase(),
            seriesUseCase: buildSeriesUseCase(),
            comicUseCase: buildComicUseCase()
        )
    }

    private func makecomicRepository() -> UpdateRepository<ComicUpdateRepositoryAPIWrapper> {
        UpdateRepositoryFactory(repositoryAPIWrapper: makeRepositoryAPIWrapper())
            .makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicUpdateRepositoryAPIWrapper {
        ComicUpdateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }
    
}
