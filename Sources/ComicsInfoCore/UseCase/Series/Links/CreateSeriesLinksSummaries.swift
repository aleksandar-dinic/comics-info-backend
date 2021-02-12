//
//  CreateSeriesLinksSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CreateSeriesLinksSummaries: CreateSeriesSummariesForCharacters, CreateSeriesSummariesForComics {
    
    func createLinksSummaries(
        for item: Series,
        characters: [Character],
        comics: [Comic],
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void>
    
}

extension CreateSeriesLinksSummaries {
    
    func createLinksSummaries(
        for item: Series,
        characters: [Character],
        comics: [Comic],
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<Void> {
        createSummaries(for: characters, item: item, on: eventLoop, in: table)
            .and(createSummaries(for: comics, item: item, on: eventLoop, in: table))
            .map { _ in }
    }
    
}
