//
//  Character+CharacterDatabase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Character {

    init(from character: CharacterDatabase) {
        self.init(
            id: character.id,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            seriesID: character.getSeriesID(),
            series: character.seriesSummary.map { $0.map { Series(fromSummary: $0) } },
            comicsID: character.getComicsID()
        )
    }

}
