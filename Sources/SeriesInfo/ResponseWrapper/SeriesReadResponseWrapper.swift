//
//  SeriesReadResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import ComicsInfoCore
import Foundation
import NIO

struct SeriesReadResponseWrapper: ErrorResponseWrapper {

    private let seriesUseCase: SeriesUseCase

    init(seriesUseCase: SeriesUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    func handleRead(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let identifier = request.pathParameters?[.identifier] else {
            let response = Response(statusCode: .notFound)
            return eventLoop.makeSucceededFuture(response)
        }

        return seriesUseCase.getSeries(withID: identifier, fromDataSource: .memory, on: eventLoop)
            .map { Response(with: Domain.Series(from: $0), statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
