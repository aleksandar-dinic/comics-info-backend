//
//  SeriesCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct SeriesCreateUseCaseFactoryMock: CreateUseCaseFactory {

    let eventLoop: EventLoop
    let logger: Logger

    let isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "SeriesUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> SeriesCreateUseCase<SeriesCreateRepositoryAPIWrapper> {
        SeriesCreateUseCase(repository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> CreateRepository<SeriesCreateRepositoryAPIWrapper> {
        CreateRepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper()
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> SeriesCreateRepositoryAPIWrapper {
        SeriesCreateRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger
        )
    }

}
