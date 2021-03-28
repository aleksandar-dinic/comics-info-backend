//
//  SeriesReadResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Logging.Logger
import Foundation
import NIO

public struct SeriesReadResponseWrapper: ReadResponseWrapper {

    private let seriesUseCase: SeriesUseCase

    public init(seriesUseCase: SeriesUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return seriesUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Series(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }
    
}

