//
//  GetCharacterSummariesForSeries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetCharacterSummariesForSeries {
    
    var comicUseCase: ComicUseCase { get }
    
    func getCharacterSummariesForSeries(
        characters: [Character],
        series: [Series],
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[CharacterSummary]?>
    
}

extension GetCharacterSummariesForSeries {
    
    func getCharacterSummariesForSeries(
        characters: [Character],
        series: [Series],
        on eventLoop: EventLoop,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[CharacterSummary]?> {
        guard !characters.isEmpty, !series.isEmpty else { return eventLoop.submit { nil } }
        
        var items = [(itemID: String, summaryID: String)]()
        
        for character in characters {
            for series in series {
                items.append((.comicInfoSummaryID(for: character), .comicInfoSummaryID(for: series)))
            }
        }
        
        let criteria = GetSummaryCriteria(items: items, table: table, logger: logger)
        return comicUseCase.getSummary(on: eventLoop, with: criteria)
    }
        
    func getUpdateSummariesCriteria(
        characters: [Character],
        series: [Series],
        characterSummaries: [CharacterSummary]?,
        table: String,
        logger: Logger?
    ) -> (UpdateSummariesCriteria<CharacterSummary>, UpdateSummariesCriteria<SeriesSummary>) {
        var dict = [String: Int]()
        
        for summary in characterSummaries ?? [] {
            dict["\(summary.itemID)|\(summary.summaryID)"] = summary.count ?? 0
        }
        
        var charactersSummaries = [CharacterSummary]()
        var seriesSummaries = [SeriesSummary]()
        
        for character in characters {
            for series in series {
                let count = 1 + (dict["\(String.comicInfoSummaryID(for: character))|\(String.comicInfoSummaryID(for: series))"] ?? 0)
                charactersSummaries.append(CharacterSummary(character, link: series, count: count))
                seriesSummaries.append(SeriesSummary(series, link: character))
            }
        }
        
        let charactersSummariesCriteria = UpdateSummariesCriteria(
            items: charactersSummaries,
            table: table,
            logger: logger
        )
        let seriesSummariesCriteria = UpdateSummariesCriteria(
            items: seriesSummaries,
            table: table,
            logger: logger
        )
        
        return (charactersSummariesCriteria, seriesSummariesCriteria)
    }
    
}
