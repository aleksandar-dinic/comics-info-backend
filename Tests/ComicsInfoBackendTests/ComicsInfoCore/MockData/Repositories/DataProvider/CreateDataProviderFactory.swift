//
//  CreateDataProviderFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum CreateDataProviderFactory {
    
    static func make(items: [String: Data] = [:]) -> CreateDataProvider {
        CreateDataProvider(itemCreateDBWrapper: ItemCreateDBWrapperFactory.make(items: items))
    }
    
}
