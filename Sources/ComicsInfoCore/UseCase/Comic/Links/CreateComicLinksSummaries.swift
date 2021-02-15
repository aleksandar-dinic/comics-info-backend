//
//  CreateComicLinksSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol CreateComicLinksSummaries: CreateComicSummariesForCharacters, CreateComicSummariesForSeries {
    
    func createLinksSummaries(
        for item: Comic,
        characters: [Character],
        series: [Series],
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Void>
    
}

extension CreateComicLinksSummaries {
    
    func createLinksSummaries(
        for item: Comic,
        characters: [Character],
        series: [Series],
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<Void> {
        createSummaries(for: characters, item: item, on: eventLoop, in: table, logger: logger)
            .and(createSummaries(for: series, item: item, on: eventLoop, in: table, logger: logger))
            .map { _ in }
    }
    
}
