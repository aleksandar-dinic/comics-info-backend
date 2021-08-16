//
//  DomainSeries+Series.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Domain.CharacterSummary
import struct Domain.ComicSummary
import Foundation

extension Domain.Series {

    init(from series: Series) {
        let characters = series.characters?.map { Domain.CharacterSummary(from: $0) }
        let comics = series.comics?.map { Domain.ComicSummary(from: $0) }

        self.init(
            identifier: series.id,
            popularity: series.popularity,
            title: series.title,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            aliases: series.aliases,
            nextIdentifier: series.nextIdentifier,
            characters: characters?.sorted(by: { $0.popularity > $1.popularity }),
            comics: comics?.sorted(by: { $0.popularity > $1.popularity })
        )
    }

}

