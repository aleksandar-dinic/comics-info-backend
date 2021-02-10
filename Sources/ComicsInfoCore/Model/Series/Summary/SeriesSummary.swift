//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesSummary: ItemSummary {
    
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
