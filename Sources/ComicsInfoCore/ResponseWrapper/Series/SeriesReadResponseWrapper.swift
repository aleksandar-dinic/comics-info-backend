//
//  SeriesReadResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation
import NIO

public struct SeriesReadResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ReadResponseWrapper where APIWrapper.Item == Series, CacheProvider.Item == Series {

    private let seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>

    public init(seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
        
        let fields = getFields(from: request.pathParameters)

        let table = String.tableName(for: environment)
        return seriesUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table)
            .map { Response(with: Domain.Series(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }
    
}

