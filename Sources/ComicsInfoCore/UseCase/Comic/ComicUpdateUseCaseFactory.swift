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

public struct ComicUpdateUseCaseFactory: UpdateUseCaseFactory {

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
