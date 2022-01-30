//
//  SeriesReadResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Domain.SeriesSummary
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
        guard let id = try? request.getIDFromPathParameters() else {
            return handleList(
                on: eventLoop,
                request: request,
                environment: environment,
                logger: logger
            )
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return seriesUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Series(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }
    
    private func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        do {
            let characterID = try request.getCharacterSummaryIDFromQueryParameters()
            return seriesUseCase.getAllSummaries(
                on: eventLoop,
                summaryID: characterID,
                afterID: request.getAfterIDFromQueryParameters(),
                limit: try request.getLimitFromQueryParameters(),
                from: String.tableName(for: environment),
                logger: logger
            )
                .map { Response(with: $0.map { Domain.SeriesSummary(from: $0) }, statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
}

