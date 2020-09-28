//
//  SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesSummary {

    let itemID: String
    let summaryID: String
    let itemName: String

    let popularity: Int
    let title: String
    let description: String?
    let thumbnail: String?

    init(
        itemID: String,
        summaryID: String,
        itemName: String,
        popularity: Int,
        title: String,
        description: String?,
        thumbnail: String?
    ) {
        self.itemID = itemID
        self.summaryID = summaryID
        self.itemName = itemName
        self.popularity = popularity
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
    }

}

//extension SeriesSummary {
//
//    init(series: Series, characterID: String) {
//        self.init(
//            itemID: "character#\(characterID)",
//            summaryID: "series#\(series.identifier)",
//            itemName: "character",
//            popularity: series.popularity,
//            title: series.title,
//            description: series.description,
//            thumbnail: series.thumbnail
//        )
//    }
//
//    init(series: Series, comicID: String) {
//        self.init(
//            itemID: "comic#\(comicID)",
//            summaryID: "series#\(series.identifier)",
//            itemName: "comic",
//            popularity: series.popularity,
//            title: series.title,
//            description: series.description,
//            thumbnail: series.thumbnail
//        )
//    }
//
//}
