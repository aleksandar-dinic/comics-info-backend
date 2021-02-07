//
//  ItemCreateDBWrapperFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum ItemCreateDBWrapperFactory {
    
    static func make(items: [String: Data] = [:]) -> ItemCreateDBWrapper {
        ItemCreateDBWrapper(itemCreateDBService: MockItemCreateDBService(items: items))
    }
    
}
