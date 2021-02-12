//
//  GetComicSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol GetComicSummaries  {
    
    var comicUseCase: ComicUseCase<GetDatabaseProvider, InMemoryCacheProvider<Comic>> { get }
    
    func getSummaries(
        _ item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[ComicSummary]?>
    
}

extension GetComicSummaries {
    
    func getSummaries(
        _ item: Comic,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[ComicSummary]?> {
        var criteria = [GetSummaryCriteria<ComicSummary>]()
        
        for id in item.charactersID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Character.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        for id in item.seriesID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Series.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        guard !criteria.isEmpty else { return eventLoop.submit { nil } }
        
        return comicUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
