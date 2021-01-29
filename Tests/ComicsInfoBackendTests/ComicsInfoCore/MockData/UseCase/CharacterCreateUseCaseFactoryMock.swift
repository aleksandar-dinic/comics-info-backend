//
//  CharacterCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

struct CharacterCreateUseCaseFactoryMock: CreateUseCaseFactory {

    var eventLoop: EventLoop
    var logger: Logger

    var isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil, logger: Logger? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        self.logger = logger ?? Logger(label: "CharacterCreateUseCaseFactoryMock")
        isLocalServer = true
    }

    func makeUseCase() -> CharacterCreateUseCase<CharacterCreateRepositoryAPIWrapper> {
        CharacterCreateUseCase(
            repository: makeCharacterRepository(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

    private func makeCharacterRepository() -> CreateRepository<CharacterCreateRepositoryAPIWrapper> {
        CreateRepositoryFactory(repositoryAPIWrapper: makeRepositoryAPIWrapper())
            .makeRepository()
    }

    private func makeRepositoryAPIWrapper() -> CharacterCreateRepositoryAPIWrapper {
        CharacterCreateRepositoryAPIWrapper(repositoryAPIService: makeRepositoryAPIService())
    }

}
