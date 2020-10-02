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

    private let seriesRepository: Repository<APIWrapper, CacheService>

    public init(seriesRepository: Repository<APIWrapper, CacheService>) {
        self.seriesRepository = seriesRepository
    }

    public func create(_ item: Series) -> EventLoopFuture<Void> {
        seriesRepository.create(item)
    }

    public func getItem(
        withID itemID: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Series> {
        seriesRepository.getItem(
            withID: itemID,
            fromDataSource: dataSource
        )
    }

    public func getAllItems(
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Series]> {
        seriesRepository.getAllItems(fromDataSource: dataSource)
    }

    public func getMetadata(
        withID id: String,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<Series> {
        seriesRepository.getMetadata(
            withID: id,
            fromDataSource: dataSource
        )
    }

    public func getAllMetadata(
        withIDs ids: Set<String>,
        fromDataSource dataSource: DataSourceLayer
    ) -> EventLoopFuture<[Series]> {
        seriesRepository.getAllMetadata(withIDs: ids, fromDataSource: dataSource)
    }

}
