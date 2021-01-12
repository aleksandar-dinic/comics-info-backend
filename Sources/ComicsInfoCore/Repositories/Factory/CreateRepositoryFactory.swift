//
//  CreateRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct CreateRepositoryFactory<APIWrapper: CreateRepositoryAPIWrapper>: CreateDataProviderFactory {

    public let repositoryAPIWrapper: APIWrapper

    public func makeRepository() -> CreateRepository<APIWrapper> {
        CreateRepository(dataProvider: makeDataProvider())
    }

}
