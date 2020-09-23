//
//  SeriesCacheProvider.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct SeriesCacheProvider: SeriesCacheService {

    private let inMemoryCache: InMemoryCache<String, Series>

    init(_ inMemoryCache: InMemoryCache<String, Series> = InMemoryCache()) {
        self.inMemoryCache = inMemoryCache
    }

    func getAllSeries(on eventLoop: EventLoop) -> EventLoopFuture<[Series]> {
        let promise = eventLoop.makePromise(of: [Series].self)

        eventLoop.execute {
            guard !inMemoryCache.isEmpty else {
                return promise.fail(APIError.seriesNotFound)
            }

            promise.succeed(inMemoryCache.values)
        }

        return promise.futureResult
    }

    func getSeries(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        let promise = eventLoop.makePromise(of: Series.self)

        eventLoop.execute {
            guard let series = inMemoryCache[seriesID] else {
                return promise.fail(APIError.seriesNotFound)
            }
            promise.succeed(series)
        }

        return promise.futureResult
    }

    func save(series: [Series]) {
        series.forEach {
            inMemoryCache[$0.identifier] = $0
        }
    }

}
