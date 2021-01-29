//
//  SeriesUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation
import NIO

protocol SeriesUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    var logger: Logger { get }
    
    func buildSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>>
    
}

extension SeriesUseCaseBuilder {
    
    func buildSeriesUseCase() -> SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: LocalServer.seriesInMemoryCache,
            logger: logger
        ).makeUseCase()
    }
        
}
