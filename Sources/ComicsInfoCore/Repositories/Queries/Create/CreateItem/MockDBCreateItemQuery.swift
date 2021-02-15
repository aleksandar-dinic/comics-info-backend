//
//  MockDBCreateItemQuery.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct MockDBCreateItemQuery<Item: ComicInfoItem>: Loggable {

    let item: Item
    
    var id: String {
        item.itemID
    }
    
    func getLogs() -> [Log] {
        [Log("CreateItemQuery item: \(item)")]
    }

}
