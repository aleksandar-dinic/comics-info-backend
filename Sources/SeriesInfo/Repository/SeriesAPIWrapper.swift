//
//  SeriesAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesAPIWrapper {

    private let seriesAPIService: SeriesAPIService
    private let seriesDecoderService: SeriesDecoderService

    init(
        seriesAPIService: SeriesAPIService,
        seriesDecoderService: SeriesDecoderService
    ) {
        self.seriesAPIService = seriesAPIService
        self.seriesDecoderService = seriesDecoderService
    }

    func create(_ series: Series) -> EventLoopFuture<Void> {
        seriesAPIService.create(series)
    }

    func getAllSeries(on eventLoop: EventLoop) -> EventLoopFuture<[Series]> {
        seriesAPIService.getAllSeries(on: eventLoop).flatMapThrowing {
            try seriesDecoderService.decodeAllSeries(from: $0)
        }
    }

    func getSeries(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        seriesAPIService.getSeries(withID: seriesID, on: eventLoop).flatMapThrowing {
            try seriesDecoderService.decodeSeries(from: $0)
        }
    }

}
