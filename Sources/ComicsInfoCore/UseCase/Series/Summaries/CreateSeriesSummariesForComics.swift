//
//  CreateSeriesSummariesForComics.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateSeriesSummariesForComics {
    
    var createRepository: CreateRepository { get }
    
    func createSummaries(
        for comics: [Comic],
        item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool>
    
}

extension CreateSeriesSummariesForComics {
    
    func createSummaries(
        for comics: [Comic],
        item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Bool> {
        guard !comics.isEmpty else { return eventLoop.submit { false } }
        
        let comicSummaries = comics.map { ComicSummary($0, link: item) }
        let seriesSummaries = comics.map { SeriesSummary(item, link: $0) }
        
        return createRepository.createSummaries(comicSummaries, in: table)
            .and(createRepository.createSummaries(seriesSummaries, in: table))
            .map { _ in true }
    }
    
}
