//
//  SeriesRepository.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class SeriesRepository {

    private let seriesDataProvider: SeriesDataProvider

    init(seriesDataProvider: SeriesDataProvider) {
        self.seriesDataProvider = seriesDataProvider
    }

    /// Create series.
    ///
    /// - Parameter series: The series.
    /// - Returns: Future with Series value.
    func create(_ series: Series) -> EventLoopFuture<Void> {
        seriesDataProvider.create(series)
    }

    /// Gets all series.
    ///
    /// - Parameter dataSource: Layer of data source.
    /// - Returns: Future with Series value.
    func getAllSeries(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Series]> {
        seriesDataProvider.getAllSeries(fromDataSource: dataSource, on: eventLoop)
    }

    /// Gets series.
    ///
    /// - Parameters:
    ///   - seriesID: Series ID.
    ///   - dataSource: Layer of data source
    /// - Returns: Future with Series value.
    func getSeries(
        withID seriesID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        seriesDataProvider.getSeries(
            withID: seriesID,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }

}
