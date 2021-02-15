//
//  GetComicSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

protocol GetComicSummaries  {
    
    var comicUseCase: ComicUseCase { get }
    
    func getSummaries(
        _ item: Comic,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[ComicSummary]?>
    
}

extension GetComicSummaries {
    
    func getSummaries(
        _ item: Comic,
        on eventLoop: EventLoop,
        in table: String,
        logger: Logger?
    ) -> EventLoopFuture<[ComicSummary]?> {
        var items = [(itemID: String, summaryID: String)]()
        
        for id in item.charactersID ?? [] {
            items.append((.comicInfoID(for: Character.self, ID: id), .comicInfoID(for: item)))
        }
        
        for id in item.seriesID ?? [] {
            items.append((.comicInfoID(for: Series.self, ID: id), .comicInfoID(for: item)))
        }
        
        guard !items.isEmpty else { return eventLoop.submit { nil } }
        
        let criteria = GetSummaryCriteria(items: items, table: table, logger: logger)
        return comicUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
