//
//  CharacterUpdateAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum CharacterUpdateAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "CharacterCreateAPIWrapperMock"),
        encoderService: EncoderService = EncoderProvider(),
        decoderService: DecoderService = DecoderProvider(),
        tables: [String: TableMock]
    ) -> CharacterUpdateAPIWrapper {
        CharacterUpdateAPIWrapper(
            eventLoop: eventLoop,
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryUpdateAPIService(
                on: eventLoop,
                logger: logger,
                tables: tables
            ),
            encoderService: encoderService,
            decoderService: decoderService,
            seriesUseCase: SeriesUseCaseFactoryMock().makeUseCase(),
            comicUseCase: ComicUseCaseFactoryMock().makeUseCase()
        )
    }

}
