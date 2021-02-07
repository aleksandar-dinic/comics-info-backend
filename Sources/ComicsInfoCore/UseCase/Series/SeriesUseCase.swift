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
    
    public func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<Series> {
        do {
            let fields = try handleFields(fields)
            return repository.getItem(with: GetItemCriteria(itemID: ID, dataSource: dataSource, table: table))
                .flatMap { [weak self] (item: Item) in
                    guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                    return self.appendCharactersSummaries(fields: fields, item: item, withID: item.itemID, on: eventLoop, from: table)
                }
                .flatMap { [weak self] (item: Item) in
                    guard let self = self else { return eventLoop.makeFailedFuture(ComicInfoError.internalServerError) }
                    return self.appendComicsSummaries(fields: fields, item: item, withID: item.itemID, on: eventLoop, from: table)
                }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    private func appendCharactersSummaries(
        fields: Set<String>,
        item: Item,
        withID ID: String,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<Series> {
        guard fields.contains("characters") else { return eventLoop.makeSucceededFuture(item) }
        let future: EventLoopFuture<[CharacterSummary<Series>]?> = getSummaries(on: eventLoop, forID: ID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.characters = $0
                return item
            }
    }
    
    private func appendComicsSummaries(
        fields: Set<String>,
        item: Item,
        withID ID: String,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<Series> {
        guard fields.contains("comics") else { return eventLoop.makeSucceededFuture(item) }
        let future: EventLoopFuture<[ComicSummary<Series>]?> = getSummaries(on: eventLoop, forID: ID, dataSource: dataSource, from: table, by: .summaryID)
        return future.map {
                var item = item
                item.comics = $0
                return item
            }
    }

}
