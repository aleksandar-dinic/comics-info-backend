//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class CharacterUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Character, CacheService.Item == Character {

    public let repository: Repository<APIWrapper, CacheService>
    public var availableFields: Set<String> {
        ["series", "comics"]
    }

    public init(repository: Repository<APIWrapper, CacheService>) {
        self.repository = repository
    }
    
    public func getItem(
        on eventLoop: EventLoop,
        withID ID: String,
        fields: Set<String>?,
        from table: String,
        dataSource: DataSourceLayer = .memory
    ) -> EventLoopFuture<Item> {
        do {
            let fields = try handleFields(fields)
            return repository.getItem(withID: ID, dataSource: dataSource, from: table)
                .flatMap { [weak self] (item: Item) in
                    guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                    return self.appendSeriesSummaries(fields: fields, item: item, withID: ID, on: eventLoop, from: table)
                }
                .flatMap { [weak self] (item: Item) in
                    guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                    return self.appendComicsSummaries(fields: fields, item: item, withID: ID, on: eventLoop, from: table) }
                .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    private func appendSeriesSummaries(
        fields: Set<String>,
        item: Item,
        withID ID: String,
        on eventLoop: EventLoop,
        dataSource: DataSourceLayer = .memory,
        from table: String
    ) -> EventLoopFuture<Item> {
        guard fields.contains("series") else { return eventLoop.makeSucceededFuture(item) }
        return getSummaries(SeriesSummary<Character>.self, on: eventLoop, forID: ID, dataSource: dataSource, from: table)
            .map {
                var item = item
                item.series = $0
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
    ) -> EventLoopFuture<Item> {
        guard fields.contains("comics") else { return eventLoop.makeSucceededFuture(item) }
        return getSummaries(ComicSummary<Character>.self, on: eventLoop, forID: ID, dataSource: dataSource, from: table)
            .map {
                var item = item
                item.comics = $0
                return item
            }
    }

}
