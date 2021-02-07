//
//  ItemGetDBWrapperFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum ItemGetDBWrapperFactory {
    
    static func make(items: [String: Data] = [:]) -> ItemGetDBWrapper<MockComicInfoItem> {
        ItemGetDBWrapper(itemGetDBService: MockItemGetDBService(items: items))
    }
    
}
