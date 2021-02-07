//
//  UpdateRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct UpdateRepositoryFactory: UpdateDataProviderFactory {

    let itemUpdateDBService: ItemUpdateDBService
    
    public func make() -> UpdateRepository {
        UpdateRepository(dataProvider: makeDataProvider())
    }

}
