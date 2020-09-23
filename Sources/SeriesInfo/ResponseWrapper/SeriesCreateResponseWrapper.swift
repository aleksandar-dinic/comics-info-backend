//
//  SeriesCreateResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import ComicsInfoCore
import Foundation
import NIO

struct SeriesCreateResponseWrapper: ErrorResponseWrapper {

    private let seriesUseCase: SeriesUseCase

    init(seriesUseCase: SeriesUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    func handleCreate(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        do {
            let series = try JSONDecoder().decode(Series.self, from: data)
            return seriesUseCase.create(series)
                .map { Response(with: ResponseMessage("Series created"), statusCode: .created) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: error, statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
