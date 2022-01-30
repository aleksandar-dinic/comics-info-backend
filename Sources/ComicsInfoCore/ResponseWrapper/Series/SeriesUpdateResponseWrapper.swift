//
//  SeriesUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Logging.Logger
import Foundation
import NIO

public struct SeriesUpdateResponseWrapper: UpdateResponseWrapper {

    private let seriesUseCase: SeriesUpdateUseCase

    public init(seriesUseCase: SeriesUpdateUseCase) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Series.self, from: data)
            let series = Series(from: item)
            let criteria = UpdateItemCriteria(
                item: series,
                oldSortValue: series.sortValue,
                on: eventLoop,
                in: table,
                log: logger
            )
            return seriesUseCase.update(with: criteria)
                .map { Response(with: Domain.Series(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }

}
