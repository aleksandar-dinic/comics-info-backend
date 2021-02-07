//
//  UpdateRepositoryFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 06/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum UpdateRepositoryFactory {
    
    static func make(items: [String: Data] = [:]) -> UpdateRepository {
        UpdateRepository(dataProvider: UpdateDataProviderFactory.make(items: items))
    }
    
}
