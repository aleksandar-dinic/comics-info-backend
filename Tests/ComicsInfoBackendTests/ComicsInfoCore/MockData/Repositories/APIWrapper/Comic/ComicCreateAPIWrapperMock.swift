//
//  ComicCreateAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum ComicCreateAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "ComicCreateAPIWrapperMock"),
        encoderService: EncoderService = EncoderProvider(),
        tables: [String: TableMock]
    ) -> ComicCreateAPIWrapper {
        ComicCreateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            ),
            encoderService: encoderService,
            characterUseCase: CharacterUseCaseFactoryMock(tables: tables).makeUseCase(),
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase()
        )
    }

}
