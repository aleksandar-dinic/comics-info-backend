//
//  SeriesCacheService.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesCacheService {

    func getAllSeries(on eventLoop: EventLoop) -> EventLoopFuture<[Series]>

    func getSeries(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series>

    func save(series: [Series])

}
