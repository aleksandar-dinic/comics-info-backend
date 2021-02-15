//
//  CreateItemCriteria.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import protocol NIO.EventLoop
import Foundation

public struct CreateItemCriteria<Item: ComicInfoItem> {
    
    let item: Item
    let eventLoop: EventLoop
    let table: String
    let logger: Logger?
    
    init(item: Item, on eventLoop: EventLoop, in table: String, log logger: Logger? = nil) {
        self.item = item
        self.eventLoop = eventLoop
        self.table = table
        self.logger = logger
    }
        
}
