//
//  ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

struct ComicSummary<Item>: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemName: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var number: String?
    
    mutating func update(with comic: Comic) {
        dateLastUpdated = Date()
        popularity = comic.popularity
        name = comic.name
        thumbnail = comic.thumbnail
        description = comic.description
    }
    
}

extension ComicSummary {
    
    init<Mapper: SummaryMapper>(_ mapper: Mapper, id: String, link: Item.Type, number: String?) {
        itemID = "\(String.getType(from: Item.self))#\(mapper.id)"
        summaryID = "\(String.getType(from: Comic.self))#\(id)"
        itemName = .getType(from: ComicSummary<Item>.self)
        popularity = mapper.popularity
        name = mapper.name
        dateAdded = Date()
        dateLastUpdated = Date()
        description = mapper.description
        thumbnail = mapper.thumbnail
        self.number = number
    }
    
    init(from item: Domain.ItemSummary, id: String, link: Item.Type, number: String?) {
        itemID = "\(String.getType(from: Item.self))#\(item.identifier)"
        summaryID = "\(String.getType(from: Comic.self))#\(id)"
        itemName = .getType(from: ComicSummary<Item>.self)
        popularity = item.popularity
        name = item.name
        dateAdded = Date()
        dateLastUpdated = Date()
        description = item.description
        thumbnail = item.thumbnail
        self.number = number
    }
    
}

extension Domain.ItemSummary {

    init<Item>(from item: ComicSummary<Item>) {
        self.init(
            identifier: item.summaryID.replacingOccurrences(of: "\(String.getType(from: Comic.self))#", with: ""),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: nil,
            number: item.number,
            roles: nil)
    }

}
