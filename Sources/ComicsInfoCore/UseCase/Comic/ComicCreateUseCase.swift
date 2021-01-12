//
//  ComicCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class ComicCreateUseCase<APIWrapper: CreateRepositoryAPIWrapper>: CreateUseCase where APIWrapper.Item == Comic {

    public let repository: CreateRepository<APIWrapper>

    public init(repository: CreateRepository<APIWrapper>) {
        self.repository = repository
    }

}
