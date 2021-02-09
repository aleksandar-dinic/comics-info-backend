//
//  SeriesListResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation
import NIO

public struct SeriesListResponseWrapper<DBService: ItemGetDBService, CacheProvider: Cacheable>: ListResponseWrapper where CacheProvider.Item == Series {

    private let seriesUseCase: SeriesUseCase<DBService, CacheProvider>

    public init(seriesUseCase: SeriesUseCase<DBService, CacheProvider>) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        let fields = getFields(from: request.queryParameters)
        
        return seriesUseCase.getAllItems(on: eventLoop, fields: fields, from: table)
            .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }

}
