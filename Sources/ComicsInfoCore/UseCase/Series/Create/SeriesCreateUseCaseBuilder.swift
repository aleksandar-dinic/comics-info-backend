//
//  SeriesCreateUseCaseBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesCreateUseCaseBuilder {
    
    var eventLoop: EventLoop { get }
    
    func buildSeriesCreateUseCase() -> SeriesCreateUseCase
    
}

extension SeriesCreateUseCaseBuilder {
    
    func buildSeriesCreateUseCase() -> SeriesCreateUseCase {
        SeriesCreateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
            .makeUseCase()
    }
    
}
