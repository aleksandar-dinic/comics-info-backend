//
//  ComicCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct ComicCreateUseCaseFactoryMock: CreateUseCaseFactory {

    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "ComicCreateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> ComicCreateUseCase<ComicCreateRepositoryAPIWrapper> {
        ComicCreateUseCase(
            repository: makeComicRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase()
        )
    }

    private func makeComicRepository() -> CreateRepository<ComicCreateRepositoryAPIWrapper> {
        CreateRepositoryFactory(
            repositoryAPIWrapper: makeRepositoryAPIWrapper()
        ).makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> ComicCreateRepositoryAPIWrapper {
        ComicCreateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

}
