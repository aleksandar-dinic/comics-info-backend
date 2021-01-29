//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

struct SeriesSummary<Item>: ItemSummary {
    
    let itemID: String
    let summaryID: String
    let itemName: String
    
    let dateAdded: Date
    private(set) var dateLastUpdated: Date
    private(set) var popularity: Int
    private(set) var name: String
    private(set) var thumbnail: String?
    private(set) var description: String?
    
    mutating func update(with series: Series) {
        dateLastUpdated = Date()
        popularity = series.popularity
        name = series.name
        thumbnail = series.thumbnail
        description = series.description
    }

}

extension SeriesSummary {

    init<Mapper: SummaryMapper>(_ mapper: Mapper, id: String, link: Item.Type) {
        itemID = "\(String.getType(from: Item.self))#\(mapper.id)"
        summaryID = "\(String.getType(from: Series.self))#\(id)"
        itemName = .getType(from: SeriesSummary<Item>.self)
        popularity = mapper.popularity
        name = mapper.name
        dateAdded = Date()
        dateLastUpdated = Date()
        description = mapper.description
        thumbnail = mapper.thumbnail
    }
    
    init(from item: Domain.ItemSummary, id: String, link: Item.Type) {
        itemID = "\(String.getType(from: Item.self))#\(item.identifier)"
        summaryID = "\(String.getType(from: Series.self))#\(id)"
        itemName = .getType(from: SeriesSummary<Item>.self)
        popularity = item.popularity
        name = item.name
        dateAdded = Date()
        dateLastUpdated = Date()
        description = item.description
        thumbnail = item.thumbnail
    }
    
}

extension Domain.ItemSummary {

    init<Item>(from item: SeriesSummary<Item>) {
        self.init(
            identifier: item.summaryID.replacingOccurrences(of: "\(String.getType(from: Series.self))#", with: ""),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: nil,
            number: nil,
            roles: nil)
    }

}
