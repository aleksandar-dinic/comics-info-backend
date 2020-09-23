//
//  SeriesListResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import ComicsInfoCore
import Foundation
import NIO

struct SeriesListResponseWrapper: ErrorResponseWrapper {

    private let seriesUseCase: SeriesUseCase

    init(seriesUseCase: SeriesUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response> {
        seriesUseCase.getAllSeries(fromDataSource: .memory, on: eventLoop)
            .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
