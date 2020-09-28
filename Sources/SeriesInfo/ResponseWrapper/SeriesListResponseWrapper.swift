//
//  SeriesListResponseWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 25/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import ComicsInfoCore
import Foundation
import NIO

struct SeriesListResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ListResponseWrapper where APIWrapper.Item == Series, CacheProvider.Item == Series {

    private let seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>

    init(seriesUseCase: SeriesUseCase<APIWrapper, CacheProvider>) {
        self.seriesUseCase = seriesUseCase
    }

    func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response> {
        seriesUseCase.getAll(fromDataSource: .memory, on: eventLoop)
            .map { Response(with: $0.map { Domain.Series(from: $0) }, statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
