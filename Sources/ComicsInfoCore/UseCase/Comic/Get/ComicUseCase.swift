//
//  ComicUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicUseCase<DBService: ItemGetDBService, CacheService: Cacheable>: GetUseCase where CacheService.Item == Comic {
    
    public let repository: GetRepository<Comic, CacheService>
    public var availableFields: Set<String> {
        ["characters", "series"]
    }

    public init(repository: GetRepository<Comic, CacheService>) {
        self.repository = repository
    }

    public func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String
    ) -> EventLoopFuture<Item> {
        appendCharactersSummaries(fields: fields, item: item, on: eventLoop, from: table)
            .and(appendSeriesSummaries(fields: fields, item: item, on: eventLoop, from: table))
            .map { charactersSummaries, seriesSummaries in
                var item = item
                item.characters = charactersSummaries
                item.series = seriesSummaries
                return  item
            }
    }
    
}

extension ComicUseCase {
    
    private func appendCharactersSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<[CharacterSummary]?> {
        guard fields.contains("characters") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(CharacterSummary.self, ID: item.itemID, dataSource: dataSource, table: table, strategy: .summaryID)
        
        return getSummaries(on: eventLoop, with: criteria)
    }
        
    private func appendSeriesSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<[SeriesSummary]?> {
        guard fields.contains("series") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(SeriesSummary.self, ID: item.itemID, dataSource: dataSource, table: table, strategy: .summaryID)
        
        return getSummaries(on: eventLoop, with: criteria)
    }

}
