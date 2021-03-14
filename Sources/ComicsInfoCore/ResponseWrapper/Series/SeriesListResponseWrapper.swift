//
//  SeriesListResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Logging.Logger
import Foundation
import NIO

public struct SeriesListResponseWrapper: ListResponseWrapper {

    private let seriesUseCase: SeriesUseCase

    public init(seriesUseCase: SeriesUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        let fields = getFields(from: request.queryParameters)
        
        return seriesUseCase.getAllItems(
            on: eventLoop,
            summaryID: nil,
            fields: fields,
            from: table,
            logger: logger
        )
            .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }

}
