//
//  CreateComicSummariesForSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateComicSummariesForSeries {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for series: [Series],
        item: Comic,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([SeriesSummary], [ComicSummary])?>
    
}

extension CreateComicSummariesForSeries {
    
    func createSummaries(
        for series: [Series],
        item: Comic,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([SeriesSummary], [ComicSummary])?> {
        guard !series.isEmpty else { return eventLoop.submit { nil } }
        
        let seriesSummariesCriteria = CreateSummariesCriteria(
            summaries: series.map { SeriesSummary($0, link: item) },
            on: eventLoop,
            in: table,
            log: logger
        )
        let comicSummariesCriteria = CreateSummariesCriteria(
            summaries: series.map { ComicSummary(item, link: $0) },
            on: eventLoop,
            in: table,
            log: logger
        )
        
        return createRepository.createSummaries(with: seriesSummariesCriteria)
            .and(createRepository.createSummaries(with: comicSummariesCriteria))
            .map { $0 }
    }
    
}
