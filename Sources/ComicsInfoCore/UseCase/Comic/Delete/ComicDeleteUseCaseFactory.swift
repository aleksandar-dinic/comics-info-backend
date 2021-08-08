//
//  ComicDeleteUseCaseFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/05/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public struct ComicDeleteUseCaseFactory: DeleteUseCaseFactory, ComicUseCaseBuilder  {

    public let eventLoop: EventLoop
    public let isLocalServer: Bool

    public init(on eventLoop: EventLoop, isLocalServer: Bool) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
    }

    public func makeUseCase() -> ComicDeleteUseCase {
        ComicDeleteUseCase(
            deleteRepository: makeDeleteRepository(),
            comicUseCase: buildComicUseCase()
        )
    }
            
}

