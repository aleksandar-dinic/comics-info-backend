//
//  TestDatabase.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct TestDatabase {
    
    static var items = [String: Data]()
    
    static func removeAll() {
        items.removeAll()
    }
    
}
