//
//  ComicReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Comic
import struct Domain.ItemSummary
import struct Logging.Logger
import Foundation
import NIO

public struct ComicReadResponseWrapper: GetPathParameterID, GetQueryParameterSeriesID, GetQueryParameterAfterID, GetQueryParameterLimit, ReadResponseWrapper {

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
        guard let id = try? getID(from: request.pathParameters) else {
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
            let seriesID = try getSeriesSummaryID(from: request.queryParameters)
            return comicUseCase.getAllSummaries(
                on: eventLoop,
                summaryID: seriesID,
                afterID: getAfterID(from: request.queryParameters),
                limit: try getLimit(from: request.queryParameters),
                from: String.tableName(for: environment),
                logger: logger
            )
                .map { Response(with: $0.map { Domain.ItemSummary(from: $0) }, statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
        } catch {
            guard let responseError = error as? ComicInfoError else {
                let message = ResponseStatus(error.localizedDescription)
                return eventLoop.submit { Response(with: message, statusCode: .badRequest) }
            }
            
            let message = ResponseStatus(for: responseError)
            return eventLoop.submit { Response(with: message, statusCode: responseError.responseStatus) }
        }
    }
    
}
