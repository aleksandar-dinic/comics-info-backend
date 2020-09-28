//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import NIO

final class SeriesUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Series, CacheService.Item == Series {

    private let seriesRepository: Repository<APIWrapper, CacheService>

    init(seriesRepository: Repository<APIWrapper, CacheService>) {
        self.seriesRepository = seriesRepository
    }

    func create(_ item: Series) -> EventLoopFuture<Void> {
        seriesRepository.create(item)
    }

    func getAll(
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<[Series]> {
        seriesRepository.getAll(fromDataSource: dataSource, on: eventLoop)
    }

    func get(
        withID identifier: String,
        fromDataSource dataSource: DataSourceLayer,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Series> {
        seriesRepository.get(
            withID: identifier,
            fromDataSource: dataSource,
            on: eventLoop
        )
    }

}
