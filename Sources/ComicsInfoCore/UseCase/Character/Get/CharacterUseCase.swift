//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class CharacterUseCase: GetUseCase {
    
    public typealias Summary = CharacterSummary

    public let repository: GetRepository<Character, InMemoryCacheProvider<Character>>
    public var availableFields: Set<String> {
        ["series", "comics"]
    }

    public init(repository: GetRepository<Character, InMemoryCacheProvider<Character>>) {
        self.repository = repository
    }
    
    public func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String,
        logger: Logger?
    ) -> EventLoopFuture<Item> {
        appendSeriesSummaries(fields: fields, item: item, on: eventLoop, from: table, logger: logger)
            .and(appendComicsSummaries(fields: fields, item: item, on: eventLoop, from: table, logger: logger))
            .map { seriesSummaries, comicsSummaries in
                var item = item
                item.series = seriesSummaries
                item.comics = comicsSummaries
                return item
            }
    }
    
}

extension CharacterUseCase {
    
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
    
    private func appendComicsSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        limit: Int = .queryLimit,
        from table: String,
        logger: Logger?
    ) -> EventLoopFuture<[ComicSummary]?> {
        guard fields.contains("comics") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(
            ComicSummary.self,
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
