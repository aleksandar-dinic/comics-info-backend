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
            .flatMap { [weak self] (item: Item) in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.appendSeriesSummaries(fields: fields, item: item, on: eventLoop, from: table)
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
    ) -> EventLoopFuture<Item> {
        guard fields.contains("characters") else { return eventLoop.submit { item } }
        let future: EventLoopFuture<[CharacterSummary<Comic>]?> = getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.characters = $0
                return item
            }
    }
        
    private func appendSeriesSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<Item> {
        guard fields.contains("series") else { return eventLoop.submit { item } }
        let future: EventLoopFuture<[SeriesSummary<Comic>]?> = getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.series = $0
                return item
            }
    }

}
