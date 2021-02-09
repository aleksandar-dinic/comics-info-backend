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
            .flatMap { [weak self] (item: Item) in
                guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                return self.appendComicsSummaries(fields: fields, item: item, on: eventLoop, from: table)
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
    ) -> EventLoopFuture<Item> {
        guard fields.contains("series") else { return eventLoop.submit { item } }
        let future: EventLoopFuture<[SeriesSummary<Character>]?> = getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.series = $0
                return item
            }
    }
    
    private func appendComicsSummaries(
        fields: Set<String>,
        item: Item,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<Item> {
        guard fields.contains("comics") else { return eventLoop.submit { item } }
        let future: EventLoopFuture<[ComicSummary<Character>]?> = getSummaries(on: eventLoop, forID: item.itemID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.comics = $0
                return item
            }
    }

}
