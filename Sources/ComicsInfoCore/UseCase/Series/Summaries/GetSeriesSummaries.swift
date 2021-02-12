//
//  GetSeriesSummaries.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 12/02/2021.
//

import Foundation
import NIO

protocol GetSeriesSummaries {
    
    var seriesUseCase: SeriesUseCase<GetDatabaseProvider, InMemoryCacheProvider<Series>> { get }
    
    func getSummaries(
        _ item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[SeriesSummary]?>
    
}

extension GetSeriesSummaries {
 
    func getSummaries(
        _ item: Series,
        on eventLoop: EventLoop,
        in table: String
    ) -> EventLoopFuture<[SeriesSummary]?> {
        var criteria = [GetSummaryCriteria<SeriesSummary>]()
        
        for id in item.charactersID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Character.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        for id in item.comicsID ?? [] {
            criteria.append(GetSummaryCriteria(
                                itemID: .comicInfoID(for: Comic.self, ID: id),
                                summaryID: .comicInfoID(for: item),
                                table: table
            ))
        }
        
        guard !criteria.isEmpty else { return eventLoop.submit { nil } }
        
        return seriesUseCase.getSummary(on: eventLoop, with: criteria)
    }
    
}
