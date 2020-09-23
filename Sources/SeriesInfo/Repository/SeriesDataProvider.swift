//
//  SeriesDataProvider.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct SeriesDataProvider {

    private let seriesAPIWrapper: SeriesAPIWrapper
    private let seriesCacheService: SeriesCacheService

    init(
        seriesAPIWrapper: SeriesAPIWrapper,
        seriesCacheService: SeriesCacheService
    ) {
        self.seriesAPIWrapper = seriesAPIWrapper
        self.seriesCacheService = seriesCacheService
    }

    // Create series.

    func create(_ series: Series) -> EventLoopFuture<Void> {
        seriesAPIWrapper.create(series)
    }

    // Get all series

    func getAllSeries(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Series]> {
        switch dataSource {
        case .memory:
            return getAllSeriesFromMemory(on: eventLoop)

        case .database:
            return getAllSeriesFromDatabase(on: eventLoop)
        }
    }

    private func getAllSeriesFromMemory(on eventLoop: EventLoop) -> EventLoopFuture<[Series]> {
        seriesCacheService.getAllSeries(on: eventLoop).map {
            $0.sorted(by: { $0.popularity < $1.popularity })
        }.flatMapError { _ in
            getAllSeriesFromDatabase(on: eventLoop)
        }
    }

    private func getAllSeriesFromDatabase(on eventLoop: EventLoop) -> EventLoopFuture<[Series]> {
        seriesAPIWrapper.getAllSeries(on: eventLoop).map {
            $0.sorted(by: { $0.popularity < $1.popularity })
        }.always { result in
            guard let series = try? result.get() else { return }
            seriesCacheService.save(series: series)
        }
    }

    // Get series

    func getSeries(
        withID seriesID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        switch dataSource {
        case .memory:
            return getSeriesFromMemory(withID: seriesID, on: eventLoop)

        case .database:
            return getSeriesFromDatabase(withID: seriesID, on: eventLoop)
        }
    }

    private func getSeriesFromMemory(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series>  {
        seriesCacheService.getSeries(withID: seriesID, on: eventLoop).flatMapError { _ in
            getSeriesFromDatabase(withID: seriesID, on: eventLoop)
        }
    }

    private func getSeriesFromDatabase(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        seriesAPIWrapper.getSeries(withID: seriesID, on: eventLoop).always { result in
            guard let series = try? result.get() else { return }
            seriesCacheService.save(series: [series])
        }
    }

}
