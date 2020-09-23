//
//  SeriesAPIService.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesAPIService {

    func create(_ series: Series) -> EventLoopFuture<Void>

    func getAllSeries(on eventLoop: EventLoop) -> EventLoopFuture<[[String: Any]]?>

    func getSeries(
        withID seriesID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[String: Any]?>

}
