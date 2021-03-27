//
//  CreateCharacterSummariesForSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateCharacterSummariesForSeries {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for series: [Series],
        item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([SeriesSummary], [CharacterSummary])?>
    
}

extension CreateCharacterSummariesForSeries {
    
    func createSummaries(
        for series: [Series],
        item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([SeriesSummary], [CharacterSummary])?> {
        guard !series.isEmpty else { return eventLoop.submit { nil } }
        
        let seriesSummariesCriteria = CreateSummariesCriteria(
            summaries: series.map { SeriesSummary($0, link: item) },
            on: eventLoop,
            in: table,
            log: logger
        )
        let characterSummariesCriteria = CreateSummariesCriteria(
            summaries: series.map { CharacterSummary(item, link: $0, count: nil) },
            on: eventLoop,
            in: table,
            log: logger
        )
        
        return createRepository.createSummaries(with: seriesSummariesCriteria)
            .and(createRepository.createSummaries(with: characterSummariesCriteria))
            .map { $0 }
    }
    
}
