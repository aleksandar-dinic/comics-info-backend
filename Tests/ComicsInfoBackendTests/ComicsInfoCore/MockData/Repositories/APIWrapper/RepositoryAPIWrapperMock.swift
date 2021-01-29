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
        items: [String: Data]
    ) -> CharacterRepositoryAPIWrapper {
        CharacterRepositoryAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryAPIService(
                on: eventLoop,
                logger: logger,
                items: items
            )
        )
    }
    
    static func makeCharacterRepositoryUpdateAPIWrapper(
        on eventLoop: EventLoop,
        logger: Logger,
        items: [String: Data]
    ) -> CharacterUpdateRepositoryAPIWrapper {
        CharacterUpdateRepositoryAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryUpdateAPIService(
                on: eventLoop,
                logger: logger,
                items: items
            )
        )
    }
    
    static func makeCharacterRepositoryCreateAPIWrapper(
        on eventLoop: EventLoop,
        logger: Logger
    ) -> CharacterCreateRepositoryAPIWrapper {
        CharacterCreateRepositoryAPIWrapper(
            repositoryAPIService: RepositoryAPIServiceMock.makeRepositoryCreateAPIService(
                on: eventLoop,
                logger: logger
            )
        )
    }

}
