//
//  ComicUpdateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct ComicUpdateUseCaseFactoryMock: UpdateUseCaseFactory {

    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "ComicUpdateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> ComicUpdateUseCase<ComicUpdateRepositoryAPIWrapper> {
        ComicUpdateUseCase(repository: makecomicRepository())
    }

    private func makecomicRepository() -> UpdateRepository<ComicUpdateRepositoryAPIWrapper> {
        UpdateRepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper()
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicUpdateRepositoryAPIWrapper {
        ComicUpdateRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: makeRepositoryAPIService(),
            logger: logger
        )
    }

}
