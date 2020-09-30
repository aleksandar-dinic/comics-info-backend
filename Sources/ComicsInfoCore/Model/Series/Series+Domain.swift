//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Domain
import Foundation

extension Domain.Series {

    init(from series: Series) {
        self.init(
            identifier: series.id,
            popularity: series.popularity,
            title: series.title,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            nextIdentifier: series.nextIdentifier,
            characters: series.characters.map { $0.map { Domain.Character(from: $0) } },
            comics: nil // TODO: - series.comics
        )
    }

}
