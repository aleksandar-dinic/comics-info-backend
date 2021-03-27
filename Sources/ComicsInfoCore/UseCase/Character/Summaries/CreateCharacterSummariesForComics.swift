//
//  CreateCharacterSummariesForComics.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateCharacterSummariesForComics {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for comics: [Comic],
        item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([ComicSummary], [CharacterSummary])?>
    
}

extension CreateCharacterSummariesForComics {
    
    func createSummaries(
        for comics: [Comic],
        item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<([ComicSummary], [CharacterSummary])?> {
        guard !comics.isEmpty else { return eventLoop.submit { nil } }
        
        let comicSummariesCriteria = CreateSummariesCriteria(
            summaries: comics.map { ComicSummary($0, link: item) },
            on: eventLoop,
            in: table,
            log: logger
        )
        let characterSummariesCriteria = CreateSummariesCriteria(
            summaries: comics.map { CharacterSummary(item, link: $0, count: nil) },
            on: eventLoop,
            in: table,
            log: logger
        )

        return createRepository.createSummaries(with: comicSummariesCriteria)
            .and(createRepository.createSummaries(with: characterSummariesCriteria))
            .map { $0 }
    }
    
}
