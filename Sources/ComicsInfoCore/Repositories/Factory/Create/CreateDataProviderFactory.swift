//
//  CreateDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CreateDataProviderFactory: ItemCreateDBWrapperFactory {

    func makeDataProvider() -> CreateDataProvider

}

extension CreateDataProviderFactory {

    func makeDataProvider() -> CreateDataProvider {
        CreateDataProvider(itemCreateDBWrapper: makeItemCreateDBService())
    }

}
