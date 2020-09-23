//
//  SeriesRepositoryFactory.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesRepositoryFactory: SeriesDataProviderFactory {

    let seriesAPIService: SeriesAPIService
    let seriesCacheService: SeriesCacheService
    let seriesDecoderService: SeriesDecoderService

    init(
        seriesAPIService: SeriesAPIService,
        seriesCacheService: SeriesCacheService = SeriesInfo.seriesCacheProvider,
        seriesDecoderService: SeriesDecoderService = SeriesDecoderProvider()
    ) {
        self.seriesAPIService = seriesAPIService
        self.seriesCacheService = seriesCacheService
        self.seriesDecoderService = seriesDecoderService
    }

    func makeSeriesRepository() -> SeriesRepository {
        SeriesRepository(seriesDataProvider: makeSeriesDataProvider())
    }

}
