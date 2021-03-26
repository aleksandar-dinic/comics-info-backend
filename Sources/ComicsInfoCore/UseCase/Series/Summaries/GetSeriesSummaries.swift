//
//  GetSeriesSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetSeriesSummaries {
    
    var seriesUseCase: SeriesUseCase { get }
    
    func getSummaries(
        _ item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[SeriesSummary]?>
    
}

extension GetSeriesSummaries {
 
    func getSummaries(
        _ item: Series,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[SeriesSummary]?> {
        var items = [(itemID: String, summaryID: String)]()
        
        for id in item.charactersID ?? [] {
            items.append((.comicInfoID(for: CharacterSummary.self, ID: id), .comicInfoSummaryID(for: item)))
        }
        
        for id in item.comicsID ?? [] {
            items.append((.comicInfoID(for: ComicSummary.self, ID: id), .comicInfoSummaryID(for: item)))
        }
        
        guard !items.isEmpty else { return eventLoop.submit { nil } }
        
        let criteria = GetSummaryCriteria(items: items, table: table, logger: logger)
        return seriesUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
