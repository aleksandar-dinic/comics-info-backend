//
//  SeriesDatabase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesDatabase {

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?
    let startYear: Int?
    let endYear: Int?
    let nextIdentifier: String?

}

extension SeriesDatabase {

    init(series: Series) {
        itemID = series.identifier
        summaryID = series.identifier
        itemName = String(describing: type(of: series))
        popularity = series.popularity
        title = series.title
        description = series.description
        thumbnail = series.thumbnail
        startYear = series.startYear
        endYear = series.endYear
        nextIdentifier = series.nextIdentifier
    }

}
