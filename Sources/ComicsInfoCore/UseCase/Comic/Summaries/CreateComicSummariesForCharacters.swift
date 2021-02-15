//
//  CreateComicSummariesForCharacters.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateComicSummariesForCharacters {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for characters: [Character],
        item: Comic,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Bool>
    
}

extension CreateComicSummariesForCharacters {
    
    func createSummaries(
        for characters: [Character],
        item: Comic,
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
        let comicSummariesCriteria = CreateSummariesCriteria(
            summaries: characters.map { ComicSummary(item, link: $0) },
            on: eventLoop,
            in: table,
            log: logger
        )
        
        return createRepository.createSummaries(with: characterSummariesCriteria)
            .and(createRepository.createSummaries(with: comicSummariesCriteria))
            .map { _ in true }
    }
    
}
