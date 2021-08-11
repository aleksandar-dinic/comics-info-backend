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

public struct SeriesReadResponseWrapper: GetPathParameterID, GetQueryParameterAfterID, GetQueryParameterLimit, ReadResponseWrapper {

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
            return seriesUseCase.getAllItems(
                on: eventLoop,
                afterID: getAfterID(from: request.queryParameters),
                fields: getFields(from: request.queryParameters),
                limit: try getLimit(from: request.queryParameters),
                from: String.tableName(for: environment),
                logger: logger
            )
                .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
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

