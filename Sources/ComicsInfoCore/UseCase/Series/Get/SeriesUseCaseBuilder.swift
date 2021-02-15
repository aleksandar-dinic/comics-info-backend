//
//  SeriesUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    
    func buildSeriesUseCase() -> SeriesUseCase
    
}

extension SeriesUseCaseBuilder {
    
    func buildSeriesUseCase() -> SeriesUseCase {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache
        ).makeUseCase()
    }
        
}
