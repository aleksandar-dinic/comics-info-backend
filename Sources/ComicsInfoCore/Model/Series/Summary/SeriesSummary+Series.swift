//
//  SeriesSummary+Series.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension SeriesSummary {

    init(_ series: Series, id: String) {
        self.init(
            itemID: "\(String.getType(from: Series.self))#\(series.id)",
            summaryID: "\(String.getType(from: Item.self))#\(id)",
            itemName: .getType(from: SeriesSummary<Item>.self),
            dateAdded: Date(),
            dateLastUpdated: Date(),
            popularity: series.popularity,
            name: series.name,
            thumbnail: series.thumbnail,
            description: series.description
        )
    }
    
}
