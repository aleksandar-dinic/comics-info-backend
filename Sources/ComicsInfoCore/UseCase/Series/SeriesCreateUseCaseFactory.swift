//
//  SeriesCreateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

public struct SeriesCreateUseCaseFactory: CreateUseCaseFactory, CharacterUseCaseBuilder, ComicUseCaseBuilder {

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

    public func makeUseCase() -> SeriesCreateUseCase {
        SeriesCreateUseCase(
            repository: makeCreateRepository(),
            characterUseCase: buildCharacterUseCase(),
            comicUseCase: buildComicUseCase()
        )
    }

}
