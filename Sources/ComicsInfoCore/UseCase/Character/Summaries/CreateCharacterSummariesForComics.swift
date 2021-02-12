//
//  CreateCharacterSummariesForComics.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateCharacterSummariesForComics {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for comics: [Comic],
        item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool>
    
}

extension CreateCharacterSummariesForComics {
    
    func createSummaries(
        for comics: [Comic],
        item: Character,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !comics.isEmpty else { return eventLoop.submit { false } }
        
        let comicSummaries = comics.map { ComicSummary($0, link: item) }
        let characterSummaries = comics.map { CharacterSummary(item, link: $0, count: nil) }
        
        return createRepository.createSummaries(comicSummaries, in: table)
            .and(createRepository.createSummaries(characterSummaries, in: table))
            .map { _ in true }
    }
    
}
