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

public struct SeriesListResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ListResponseWrapper where APIWrapper.Item == Series, CacheProvider.Item == Series {

    private let seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>

    public init(seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>) {
        self.seriesUseCase = seriesUseCase
    }

    public func handleList(on eventLoop: EventLoop, environment: String?) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        return seriesUseCase.getAllItems(fromDataSource: .memory, from: table)
            .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
