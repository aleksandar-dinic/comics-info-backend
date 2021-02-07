//
//  ItemUpdateDBWrapperFactory.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

enum ItemUpdateDBWrapperFactory {
    
    static func make(items: [String: Data] = [:]) -> ItemUpdateDBWrapper {
        ItemUpdateDBWrapper(itemUpdateDBService: MockItemUpdateDBService(items: items))
    }
    
}
