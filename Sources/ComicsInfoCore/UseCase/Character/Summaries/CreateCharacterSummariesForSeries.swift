//
//  CreateCharacterSummariesForSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateCharacterSummariesForSeries {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for series: [Series],
        item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool>
    
}

extension CreateCharacterSummariesForSeries {
    
    func createSummaries(
        for series: [Series],
        item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !series.isEmpty else { return eventLoop.submit { false } }
        
        let seriesSummaries = series.map { SeriesSummary($0, link: item) }
        let characterSummaries = series.map { CharacterSummary(item, link: $0, count: nil) }
        
        return createRepository.createSummaries(seriesSummaries, in: table)
            .and(createRepository.createSummaries(characterSummaries, in: table))
            .map { _ in true }
    }
    
}
