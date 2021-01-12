//
//  UpdateRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct UpdateRepositoryFactory<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateDataProviderFactory {

    public let repositoryAPIWrapper: APIWrapper

    public func makeRepository() -> UpdateRepository<APIWrapper> {
        UpdateRepository(dataProvider: makeDataProvider())
    }

}
