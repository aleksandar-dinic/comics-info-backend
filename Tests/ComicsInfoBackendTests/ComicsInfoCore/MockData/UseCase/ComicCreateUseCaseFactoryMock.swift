//
//  ComicCreateUseCaseFactoryMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

struct ComicCreateUseCaseFactoryMock: CreateUseCaseFactory, UpdateRepositoryBuilder {

    var eventLoop: EventLoop

    var isLocalServer: Bool

    init(on eventLoop: EventLoop? = nil) {
        self.eventLoop = eventLoop ?? MultiThreadedEventLoopGroup(numberOfThreads: 1).next()
        isLocalServer = true
    }

    func makeUseCase() -> ComicCreateUseCase {
        ComicCreateUseCase(
            createRepository: makeCreateRepository(),
            updateRepository: makeUpdateRepository(),
            characterUseCase: CharacterUseCaseFactoryMock().makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

}
