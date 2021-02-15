//
//  CreateSeriesSummariesForCharacters.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateSeriesSummariesForCharacters {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for characters: [Character],
        item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool>
    
}

extension CreateSeriesSummariesForCharacters {
    
    func createSummaries(
        for characters: [Character],
        item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool> {
        guard !characters.isEmpty else { return eventLoop.submit { false } }
        
        let characterSummariesCriteria = CreateSummariesCriteria(
            summaries: characters.map { CharacterSummary($0, link: item, count: nil) },
            on: eventLoop,
            in: table,
            log: logger
        )
        let seriesSummariesCriteria = CreateSummariesCriteria(
            summaries: characters.map { SeriesSummary(item, link: $0) },
            on: eventLoop,
            in: table,
            log: logger
        )
        
        return createRepository.createSummaries(with: characterSummariesCriteria)
            .and(createRepository.createSummaries(with: seriesSummariesCriteria))
            .map { _ in true }
    }
    
    
}
