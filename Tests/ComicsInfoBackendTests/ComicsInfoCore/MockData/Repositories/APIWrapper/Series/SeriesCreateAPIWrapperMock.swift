//
//  SeriesCreateAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum SeriesCreateAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "SeriesCreateAPIWrapperMock"),
        encoderService: EncoderService = EncoderProvider(),
        tables: [String: TableMock]
    ) -> SeriesCreateAPIWrapper {
        SeriesCreateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            ),
            encoderService: encoderService,
            characterUseCase: CharacterUseCaseFactoryMock(tables: tables).makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

}
