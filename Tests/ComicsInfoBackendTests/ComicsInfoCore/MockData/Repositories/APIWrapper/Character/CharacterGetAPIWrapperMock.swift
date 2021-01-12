//
//  CharacterGetAPIWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum CharacterGetAPIWrapperMock {

    static func make(
        on eventLoop: EventLoop = MultiThreadedEventLoopGroup(numberOfThreads: 1).next(),
        logger: Logger = Logger(label: "CharacterCreateAPIWrapperMock"),
        decoderService: DecoderService = DecoderProvider(),
        tables: [String: TableMock]
    ) -> CharacterGetAPIWrapper {
        let repositoryAPIService = RepositoryAPIServiceMock.makeRepositoryAPIService(
            on: eventLoop,
            logger: logger,
            tables: tables
        )
        return CharacterGetAPIWrapper(
            repositoryAPIService: repositoryAPIService,
            decoderService: decoderService
        )
    }

}
