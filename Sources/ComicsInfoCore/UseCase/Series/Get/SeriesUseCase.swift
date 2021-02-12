//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class SeriesUseCase<DBService: ItemGetDBService, CacheService: Cacheable>: GetUseCase where CacheService.Item == Series {

    public let repository: GetRepository<Series, CacheService>
    public var availableFields: Set<String> {
        ["characters", "comics"]
    }

    public init(repository: GetRepository<Series, CacheService>) {
        self.repository = repository
    }
    
    public func appendSummaries(
        for item: Item,
        on eventLoop: EventLoop,
        fields: Set<String>,
        table: String
    ) -> EventLoopFuture<Item> {
        appendCharactersSummaries(fields: fields, item: item, on: eventLoop, from: table)
            .and(appendComicsSummaries(fields: fields, item: item, on: eventLoop, from: table))
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
        from table: String
    ) -> EventLoopFuture<[CharacterSummary]?> {
        guard fields.contains("characters") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(CharacterSummary.self, ID: item.itemID, dataSource: dataSource, table: table, strategy: .summaryID)
        return getSummaries(on: eventLoop, with: criteria)
    }
    
    private func appendComicsSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<[ComicSummary]?> {
        guard fields.contains("comics") else { return eventLoop.submit { nil } }
        let criteria = GetSummariesCriteria(ComicSummary.self, ID: item.itemID, dataSource: dataSource, table: table, strategy: .summaryID)
        return getSummaries(on: eventLoop, with: criteria)
    }

}
