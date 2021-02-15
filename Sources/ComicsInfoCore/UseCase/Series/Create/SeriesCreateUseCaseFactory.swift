//
//  SeriesCreateUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct SeriesCreateUseCaseFactory: CreateUseCaseFactory, CharacterUseCaseBuilder, SeriesUseCaseBuilder, ComicUseCaseBuilder {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool

    public init(on eventLoop: EventLoop, isLocalServer: Bool) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
    }

    public func makeUseCase() -> SeriesCreateUseCase {
        SeriesCreateUseCase(
            createRepository: makeCreateRepository(),
            characterUseCase: buildCharacterUseCase(),
            seriesUseCase: buildSeriesUseCase(),
            comicUseCase: buildComicUseCase()
        )
    }

}
