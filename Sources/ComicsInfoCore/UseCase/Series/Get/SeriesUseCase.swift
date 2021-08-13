//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public final class SeriesUseCase: GetUseCase {

    public typealias Summary = SeriesSummary
    
    public let repository: GetRepository<Series, InMemoryCacheProvider<Series>>
    public var availableFields: Set<String> {
        ["characters", "comics"]
    }

    public init(repository: GetRepository<Series, InMemoryCacheProvider<Series>>) {
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
            .and(appendComicsSummaries(fields: fields, item: item, on: eventLoop, from: table, logger: logger))
            .map { charactersSummaries, comicsSummaries in
                var item = item
                item.characters = charactersSummaries
                item.comics = comicsSummaries
                return item
            }
    }
    
}

extension SeriesUseCase {
    
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
