//
//  SeriesSummary+Series.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension SeriesSummary {

    init<Summary: Identifiable>(_ series: Series, link: Summary) {
        let now = Date()
        
        self.init(
            itemID: .comicInfoID(for: series),
            summaryID: .comicInfoID(for: link),
            itemName: .getType(from: SeriesSummary.self),
            dateAdded: now,
            dateLastUpdated: now,
            popularity: series.popularity,
            name: series.name,
            thumbnail: series.thumbnail,
            description: series.description
        )
    }
    
}
