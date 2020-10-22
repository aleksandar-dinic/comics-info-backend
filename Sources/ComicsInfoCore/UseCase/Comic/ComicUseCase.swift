//
//  ComicUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class ComicUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Comic, CacheService.Item == Comic {

    public let repository: Repository<APIWrapper, CacheService>

    public init(repository: Repository<APIWrapper, CacheService>) {
        self.repository = repository
    }

}
