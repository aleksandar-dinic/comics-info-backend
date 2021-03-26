//
//  GetCharacterSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetCharacterSummaries {
    
    var characterUseCase: CharacterUseCase { get }
    
    func getSummaries(
        _ item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[CharacterSummary]?>
    
}

extension GetCharacterSummaries {
    
    func getSummaries(
        _ item: Character,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[CharacterSummary]?> {
        var items = [(itemID: String, summaryID: String)]()
        
        for id in item.seriesID ?? [] {
            items.append((.comicInfoID(for: SeriesSummary.self, ID: id), .comicInfoSummaryID(for: item)))
        }
        
        for id in item.comicsID ?? [] {
            items.append((.comicInfoID(for: ComicSummary.self, ID: id), .comicInfoSummaryID(for: item)))
        }
        
        guard !items.isEmpty else { return eventLoop.submit { nil } }
        
        let criteria = GetSummaryCriteria(items: items, table: table, logger: logger)
        return characterUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
