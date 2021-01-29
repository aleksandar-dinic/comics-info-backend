//
//  SeriesUpdateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct SeriesUpdateUseCaseFactoryMock: UpdateUseCaseFactory {

    let eventLoop: EventLoop
    let logger: Logger

    let isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "SeriesUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> SeriesUpdateUseCase<SeriesUpdateRepositoryAPIWrapper> {
        SeriesUpdateUseCase(
            repository: makeSeriesRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

    private func makeSeriesRepository() -> UpdateRepository<SeriesUpdateRepositoryAPIWrapper> {
        UpdateRepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper()
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesUpdateRepositoryAPIWrapper {
        SeriesUpdateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

}
