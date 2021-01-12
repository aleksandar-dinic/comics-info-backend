//
//  TableMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 11/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct TableMock {
    
    let name: String
    var items: [String: DatabaseItem]

    init(name: String) {
        self.name = name
        items = [String: DatabaseItem]()
    }

}
