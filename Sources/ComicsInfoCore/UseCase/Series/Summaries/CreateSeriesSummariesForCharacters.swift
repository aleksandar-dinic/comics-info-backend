//
//  CreateSeriesSummariesForCharacters.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateSeriesSummariesForCharacters {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for characters: [Character],
        item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool>
    
}

extension CreateSeriesSummariesForCharacters {
    
    func createSummaries(
        for characters: [Character],
        item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !characters.isEmpty else { return eventLoop.submit { false } }
        
        let characterSummaries = characters.map { CharacterSummary($0, link: item, count: nil) }
        let seriesSummaries = characters.map { SeriesSummary(item, link: $0) }
        
        return createRepository.createSummaries(characterSummaries, in: table)
            .and(createRepository.createSummaries(seriesSummaries, in: table))
            .map { _ in true }
    }
    
    
}
