//
//  DeleteRepositoryFactory.swift
//  ComicInfo
//
//  Created by Aleksandar Dinic on 04/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct DeleteRepositoryFactory: DeleteDataProviderFactory {

    let itemDeleteDBService: ItemDeleteDBService
    
    public func make() -> DeleteRepository {
        DeleteRepository(dataProvider: makeDataProvider())
    }

}
