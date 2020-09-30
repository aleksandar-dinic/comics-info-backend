//
//  Series+SeriesDatabase.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Series {

    init(from series: SeriesDatabase) {
        self.init(
            id: series.summaryID,
            popularity: series.popularity,
            title: series.title,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            nextIdentifier: series.nextIdentifier,
            charactersID: series.getCharactersID(),
            characters: series.charactersSummary.map { $0.map { Character(fromSummary: $0) } },
            comicsID: series.getComicsID()
        )
    }

}
