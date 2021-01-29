//
//  SeriesUpdateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesUpdateUseCaseFactory: UpdateUseCaseFactory, CharacterUseCaseBuilder, SeriesUseCaseBuilder, ComicUseCaseBuilder {

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

    public func makeUseCase() -> SeriesUpdateUseCase<SeriesUpdateRepositoryAPIWrapper> {
        SeriesUpdateUseCase(
            repository: makeSeriesRepository(),
            characterUseCase: buildCharacterUseCase(),
            seriesUseCase: buildSeriesUseCase(),
            comicUseCase: buildComicUseCase()
        )
    }

    private func makeSeriesRepository() -> UpdateRepository<SeriesUpdateRepositoryAPIWrapper> {
        UpdateRepositoryFactory(repositoryAPIWrapper: makeRepositoryAPIWrapper())
            .makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesUpdateRepositoryAPIWrapper {
        SeriesUpdateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }
    
}
