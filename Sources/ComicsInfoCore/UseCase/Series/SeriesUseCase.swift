//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class SeriesUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Series, CacheService.Item == Series {
    
    public let repository: Repository<APIWrapper, CacheService>
    public var availableFields: Set<String> {
        ["characters", "comics"]
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
                    return self.appendCharactersSummaries(fields: fields, item: item, withID: ID, on: eventLoop, from: table)
                }
                .flatMap { [weak self] (item: Item) in
                    guard let self = self else { return eventLoop.makeFailedFuture(APIError.internalServerError) }
                    return self.appendComicsSummaries(fields: fields, item: item, withID: ID, on: eventLoop, from: table)
                }
                .flatMapErrorThrowing { throw $0.mapToAPIError(itemType: Item.self) }
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
    ) -> EventLoopFuture<Item> {
        guard fields.contains("characters") else { return eventLoop.makeSucceededFuture(item) }
        return getSummaries(CharacterSummary<Series>.self, forID: ID, dataSource: dataSource, from: table)
            .map {
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
    ) -> EventLoopFuture<Item> {
        guard fields.contains("comics") else { return eventLoop.makeSucceededFuture(item) }
        return getSummaries(ComicSummary<Series>.self, forID: ID, dataSource: dataSource, from: table)
            .map {
                var item = item
                item.comics = $0
                return item
            }
    }

}
