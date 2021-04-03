//
//  DeleteDataProviderFactory.swift
//  ComicInfo
//
//  Created by Aleksandar Dinic on 03/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol DeleteDataProviderFactory: ItemDeleteDBWrapperFactory {

    func makeDataProvider() -> DeleteDataProvider

}

extension DeleteDataProviderFactory {

    func makeDataProvider() -> DeleteDataProvider {
        DeleteDataProvider(itemDeleteDBWrapper: makeItemDeleteDBWrapper())
    }

}
