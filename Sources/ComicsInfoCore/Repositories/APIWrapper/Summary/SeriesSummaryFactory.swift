//
//  SeriesSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesSummaryFactory: MissingIDsHandler, SummariesFactory {
    
    var seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> { get }
    
}

extension SeriesSummaryFactory {
    
    func getSeries(
        on eventLoop: EventLoop,
        forIDs seriesID: Set<String>?,
        from table: String
    ) -> EventLoopFuture<[Series]> {
        guard let seriesID = seriesID else {
            return eventLoop.submit { [] }
        }

        return seriesUseCase.getItems(on: eventLoop, withIDs: seriesID, from: table)
            .flatMapThrowing { try handleMissingIDs($0, IDs: seriesID) }
    }
    
}
