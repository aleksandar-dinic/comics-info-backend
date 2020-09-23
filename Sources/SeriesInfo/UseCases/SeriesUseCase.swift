//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class SeriesUseCase {

    private let seriesRepository: SeriesRepository

    init(seriesRepository: SeriesRepository) {
        self.seriesRepository = seriesRepository
    }

    func create(_ series: Series) -> EventLoopFuture<Void> {
        seriesRepository.create(series)
    }

    func getAllSeries(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Series]> {
        seriesRepository.getAllSeries(fromDataSource: dataSource, on: eventLoop)
    }

    func getSeries(
        withID seriesID: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        seriesRepository.getSeries(
            withID: seriesID,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }

}
