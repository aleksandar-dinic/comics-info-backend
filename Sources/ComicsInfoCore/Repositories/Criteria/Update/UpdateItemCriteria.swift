//
//  UpdateItemCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import protocol NIO.EventLoop
import Foundation

public struct UpdateItemCriteria<Item: ComicInfoItem> {
    
    let item: Item
    let oldSortValue: String
    let eventLoop: EventLoop
    let table: String
    let logger: Logger?
    
    init(
        item: Item,
        oldSortValue: String,
        on eventLoop: EventLoop,
        in table: String,
        log logger: Logger? = nil
    ) {
        self.item = item
        self.oldSortValue = oldSortValue
        self.eventLoop = eventLoop
        self.table = table
        self.logger = logger
    }
    
    func updatedFields(oldItem: Item) -> Set<String> {
        item.updatedFields(old: oldItem)
    }

}
