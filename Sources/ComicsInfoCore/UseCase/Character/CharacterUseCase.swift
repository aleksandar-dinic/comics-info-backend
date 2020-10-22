//
//  CharacterUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 04/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class CharacterUseCase<APIWrapper: RepositoryAPIWrapper, CacheService: Cacheable>: UseCase where APIWrapper.Item == Character, CacheService.Item == Character {

    public let repository: Repository<APIWrapper, CacheService>

    public init(repository: Repository<APIWrapper, CacheService>) {
        self.repository = repository
    }

}
