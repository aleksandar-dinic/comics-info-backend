//
//  ComicUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    
    func buildComicUseCase() -> ComicUseCase
    
}

extension ComicUseCaseBuilder {
    
    func buildComicUseCase() -> ComicUseCase {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.comicInMemoryCache
        ).makeUseCase()
    }
    
}
