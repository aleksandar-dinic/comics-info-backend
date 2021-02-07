//
//  CreateRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct CreateRepositoryFactory: CreateDataProviderFactory {

    let itemCreateDBService: ItemCreateDBService
    
    public func make() -> CreateRepository {
        CreateRepository(dataProvider: makeDataProvider())
    }

}
