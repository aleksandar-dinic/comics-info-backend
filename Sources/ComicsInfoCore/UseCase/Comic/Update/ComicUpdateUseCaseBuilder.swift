//
//  ComicUpdateUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol ComicUpdateUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    
    func buildComicUpdateUseCase() -> ComicUpdateUseCase
    
}

extension ComicUpdateUseCaseBuilder {
    
    func buildComicUpdateUseCase() -> ComicUpdateUseCase {
        ComicUpdateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
            .makeUseCase()
    }
    
}
