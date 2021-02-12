//
//  CreateComicSummariesForSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateComicSummariesForSeries {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for series: [Series],
        item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool>
    
}

extension CreateComicSummariesForSeries {
    
    func createSummaries(
        for series: [Series],
        item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !series.isEmpty else { return eventLoop.submit { false } }
        
        let seriesSummaries = series.map { SeriesSummary($0, link: item) }
        let comicSummaries = series.map { ComicSummary(item, link: $0) }
        
        return createRepository.createSummaries(seriesSummaries, in: table)
            .and(createRepository.createSummaries(comicSummaries, in: table))
            .map { _ in true }
    }
    
}
