//
//  SeriesUseCase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class SeriesUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Series, CacheService.Item == Series {

    public let repository: Repository<APIWrapper, CacheService>

    public init(repository: Repository<APIWrapper, CacheService>) {
        self.repository = repository
    }

}
