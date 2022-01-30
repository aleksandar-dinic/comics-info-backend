//
//  ComicReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Domain.ComicSummary
import struct Logging.Logger
import Foundation
import NIO

public struct ComicReadResponseWrapper: ReadResponseWrapper {

    private let comicUseCase: ComicUseCase

    public init(comicUseCase: ComicUseCase) {
        self.comicUseCase = comicUseCase
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
        return comicUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Comic(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }
    
    private func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        do {
            let seriesID = try request.getSeriesSummaryIDFromQueryParameters()
            return comicUseCase.getAllSummaries(
                on: eventLoop,
                summaryID: seriesID,
                afterID: request.getAfterIDFromQueryParameters(),
                limit: try request.getLimitFromQueryParameters(),
                from: String.tableName(for: environment),
                logger: logger
            )
                .map { Response(with: $0.map { Domain.ComicSummary(from: $0) }, statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            return eventLoop.submit { self.catch(error, statusCode: .badRequest) }
        }
    }
    
}
