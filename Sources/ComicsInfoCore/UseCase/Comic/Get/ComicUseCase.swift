//
//  ComicUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class ComicUseCase: GetUseCase {
    
    public typealias Summary = ComicSummary
    
    public let repository: GetRepository<Comic, InMemoryCacheProvider<Comic>>
    public var availableFields: Set<String> {
        ["characters", "series"]
    }

    public init(repository: GetRepository<Comic, InMemoryCacheProvider<Comic>>) {
        self.repository = repository
    }

    public func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        appendCharactersSummaries(fields: fields, item: item, on: eventLoop, from: table, logger: logger)
            .and(appendSeriesSummaries(fields: fields, item: item, on: eventLoop, from: table, logger: logger))
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
        limit: Int = .queryLimit,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[CharacterSummary]?> {
        guard fields.contains("characters") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(
            CharacterSummary.self,
            ID: item.id,
            dataSource: dataSource,
            limit: limit,
            table: table,
            strategy: .itemID,
            logger: logger
        )
        
        return getSummaries(on: eventLoop, with: criteria)
    }
        
    private func appendSeriesSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        limit: Int = .queryLimit,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[SeriesSummary]?> {
        guard fields.contains("series") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(
            SeriesSummary.self,
            ID: item.id,
            dataSource: dataSource,
            limit: limit,
            table: table,
            strategy: .itemID,
            logger: logger
        )
        
        return getSummaries(on: eventLoop, with: criteria)
    }

}
