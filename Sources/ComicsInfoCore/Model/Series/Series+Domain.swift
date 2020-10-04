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
        let characters = series.characters?.compactMap { Domain.Character(from: $0) }

        self.init(
            identifier: series.id,
            popularity: series.popularity,
            title: series.title,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            nextIdentifier: series.nextIdentifier,
            characters: characters?.sorted(by: { $0.popularity < $1.popularity }),
            comics: nil // TODO: - series.comics
        )
    }

}
