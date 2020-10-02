//
//  CacheError.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum CacheError<Item: Identifiable>: Error {

    case itemNotFound(withID: Item.ID, itemType: Item.Type)
    case itemsNotFound(itemType: Item.Type)

}
