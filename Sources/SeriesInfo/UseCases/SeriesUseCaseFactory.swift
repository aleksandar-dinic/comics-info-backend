//
//  SeriesUseCaseFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

struct SeriesUseCaseFactory {

    private let eventLoop: EventLoop
    private let isLocalServer: Bool
    private let seriesCacheService: SeriesCacheService

    init(
        on eventLoop: EventLoop,
        isLocalServer: Bool,
        seriesCacheService: SeriesCacheService = SeriesInfo.seriesCacheProvider
    ) {
        self.eventLoop = eventLoop
        self.isLocalServer = isLocalServer
        self.seriesCacheService = seriesCacheService
    }

    func makeSeriesUseCase() -> SeriesUseCase {
        SeriesUseCase(seriesRepository: makeSeriesRepository())
    }

    private func makeSeriesRepository() -> SeriesRepository {
        SeriesRepositoryFactory(
            seriesAPIService: makeSeriesAPIService(),
            seriesCacheService: seriesCacheService
        ).makeSeriesRepository()
    }

    private func makeSeriesAPIService() -> SeriesAPIService {
        SeriesDatabaseProvider(database: makeDatabase())
    }

    private func makeDatabase() -> Database {
        DatabaseFectory(isLocalServer: isLocalServer)
            .makeDatabase(eventLoop: eventLoop)
    }

}
