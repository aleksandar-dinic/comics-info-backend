//
//  Series+SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Series {

    init(fromSummary series: SeriesSummary) {
        self.init(
            id: series.id,
            popularity: series.popularity,
            title: series.title,
            dateAdded: series.dateAdded,
            dateLastUpdated: series.dateLastUpdated,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: nil,
            endYear: nil,
            aliases: nil,
            nextIdentifier: nil,
            charactersID: nil,
            characters: nil,
            comicsID: nil,
            comics: nil
        )
    }

}
