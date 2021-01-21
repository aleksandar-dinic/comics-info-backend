//
//  SeriesSummaryFuturesFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol SeriesSummaryFuturesFactory: ItemSummaryDatabaseItemFactory, ItemMetadataHandler {
    
    var seriesUseCase: SeriesUseCase<SeriesRepositoryAPIWrapper, InMemoryCacheProvider<Series>> { get }

    func getSeries(_ seriesIDs: Set<String>?, from table: String) -> EventLoopFuture<[Series]>
    
}

extension SeriesSummaryFuturesFactory {

    func getSeries(_ seriesIDs: Set<String>?, from table: String) -> EventLoopFuture<[Series]> {
        guard let seriesIDs = seriesIDs, !seriesIDs.isEmpty else {
            return handleEmptyItems()
        }

        return seriesUseCase.getAllMetadata(withIDs: seriesIDs, fromDataSource: .memory, from: table)
                .flatMapThrowing { try handleItems($0, itemsID: seriesIDs) }
    }

}
