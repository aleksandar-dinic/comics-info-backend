//
//  SeriesCreateUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public final class SeriesCreateUseCase<APIWrapper: CreateRepositoryAPIWrapper>: CreateUseCase where APIWrapper.Item == Series {

    public let repository: CreateRepository<APIWrapper>

    public init(repository: CreateRepository<APIWrapper>) {
        self.repository = repository
    }

}
