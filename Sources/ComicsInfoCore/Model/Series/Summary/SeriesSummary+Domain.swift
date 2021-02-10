//
//  SeriesSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension SeriesSummary {
    
    init<Summary: Identifiable>(from item: Domain.ItemSummary, link: Summary) {
        let now = Date()
        
        self.init(
            itemID: .comicInfoID(for: Series.self, ID: item.identifier),
            summaryID: .comicInfoID(for: link),
            itemName: .getType(from: SeriesSummary.self),
            dateAdded: now,
            dateLastUpdated: now,
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description
        )
    }
    
}
