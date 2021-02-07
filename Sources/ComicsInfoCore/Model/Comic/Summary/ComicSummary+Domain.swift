//
//  ComicSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension ComicSummary {
    
    init(from item: Domain.ItemSummary, id: String, number: String?) {
        self.init(
            itemID: "\(String.getType(from: Comic.self))#\(item.identifier)",
            summaryID: "\(String.getType(from: Item.self))#\(id)",
            itemName: .getType(from: ComicSummary<Item>.self),
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            number: number
        )
    }
    
}
