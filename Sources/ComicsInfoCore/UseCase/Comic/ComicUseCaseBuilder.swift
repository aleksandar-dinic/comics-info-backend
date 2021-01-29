//
//  ComicUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

protocol ComicUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var logger: Logger { get }
    
    func buildComicUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>>
    
}

extension ComicUseCaseBuilder {
    
    func buildComicUseCase() -> ComicUseCase<ComicRepositoryAPIWrapper, InMemoryCacheProvider<Comic>> {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache,
            logger: logger
        ).makeUseCase()
    }
    
}
