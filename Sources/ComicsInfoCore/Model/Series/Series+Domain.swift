//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import struct Domain.ItemSummary
import Foundation

extension Domain.Series {

    init(from series: Series) {
        let characters = series.characters?.compactMap { Domain.ItemSummary(from: $0) }
        let comics = series.comics?.compactMap { Domain.ItemSummary(from: $0) }

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
