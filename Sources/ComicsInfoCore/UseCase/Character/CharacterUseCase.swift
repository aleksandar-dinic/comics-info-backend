//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUseCase<DBService: ItemGetDBService, CacheService: Cacheable>: GetUseCase where CacheService.Item == Character {

    public let repository: GetRepository<Character, CacheService>
    public var availableFields: Set<String> {
        ["series", "comics"]
    }

    public init(repository: GetRepository<Character, CacheService>) {
        self.repository = repository
    }
    
    public func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String
    ) -> EventLoopFuture<Item> {
        appendSeriesSummaries(fields: fields, item: item, on: eventLoop, from: table)
            .and(appendComicsSummaries(fields: fields, item: item, on: eventLoop, from: table))
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
        from table: String
    ) -> EventLoopFuture<[SeriesSummary]?> {
        guard fields.contains("series") else { return eventLoop.submit { nil } }
        return getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
    }
    
    private func appendComicsSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<[ComicSummary]?> {
        guard fields.contains("comics") else { return eventLoop.submit { nil } }
        return getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
    }

}
