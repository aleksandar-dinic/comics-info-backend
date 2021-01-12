//
//  RepositoryAPIWrapperMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 19/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import Logging
import NIO

enum RepositoryAPIWrapperMock {

    static func makeCharacterRepositoryAPIWrapper(
        on eventLoop: EventLoop,
        logger: Logger,
        tables: [String: TableMock],
        decoderService: DecoderService = DecoderProvider()
    ) -> CharacterRepositoryAPIWrapper {
        CharacterRepositoryAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryAPIService(
                on: eventLoop,
                logger: logger,
                tables: tables
            ),
            decoderService: decoderService
        )
    }
    
    static func makeCharacterRepositoryUpdateAPIWrapper(
        on eventLoop: EventLoop,
        logger: Logger,
        tables: [String: TableMock],
        decoderService: DecoderService = DecoderProvider()
    ) -> CharacterUpdateRepositoryAPIWrapper {
        CharacterUpdateRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryUpdateAPIService(
                on: eventLoop,
                logger: logger,
                tables: tables
            ),
            logger: logger,
            decoderService: decoderService
        )
    }
    
    static func makeCharacterRepositoryCreateAPIWrapper(
        on eventLoop: EventLoop,
        logger: Logger,
        encoderService: EncoderService = EncoderProvider()
    ) -> CharacterCreateRepositoryAPIWrapper {
        CharacterCreateRepositoryAPIWrapper(
            on: eventLoop,
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            ),
            logger: logger,
            encoderService: encoderService
        )
    }

}
