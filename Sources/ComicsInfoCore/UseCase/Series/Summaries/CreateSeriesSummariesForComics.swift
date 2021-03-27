//
//  CreateSeriesSummariesForComics.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateSeriesSummariesForComics {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for comics: [Comic],
        item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([ComicSummary], [SeriesSummary])?>
    
}

extension CreateSeriesSummariesForComics {
    
    func createSummaries(
        for comics: [Comic],
        item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([ComicSummary], [SeriesSummary])?> {
        guard !comics.isEmpty else { return eventLoop.submit { nil } }
        
        let comicSummariesCriteria = CreateSummariesCriteria(
            summaries: comics.map { ComicSummary($0, link: item) },
            on: eventLoop,
            in: table,
            log: logger
        )
        let seriesSummariesCriteria = CreateSummariesCriteria(
            summaries: comics.map { SeriesSummary(item, link: $0) },
            on: eventLoop,
            in: table,
            log: logger
        )
        
        return createRepository.createSummaries(with: comicSummariesCriteria)
            .and(createRepository.createSummaries(with: seriesSummariesCriteria))
            .map { $0 }
    }
    
}
