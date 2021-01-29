//
//  ComicUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class ComicUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Comic, CacheService.Item == Comic {
    
    public let repository: Repository<APIWrapper, CacheService>
    public var availableFields: Set<String> {
        ["characters", "series"]
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
                    return self.appendSeriesSummaries(fields: fields, item: item, withID: ID, on: eventLoop, from: table)
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
        return getSummaries(CharacterSummary<Comic>.self, forID: ID, dataSource: dataSource, from: table)
            .map {
                var item = item
                item.characters = $0
                return item
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
        return getSummaries(SeriesSummary<Comic>.self, forID: ID, dataSource: dataSource, from: table)
            .map {
                var item = item
                item.series = $0
                return item
            }
    }

}
