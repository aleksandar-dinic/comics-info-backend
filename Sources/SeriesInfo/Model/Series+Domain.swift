//
//  Series+Domain.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Series
import Foundation

extension Domain.Series {

    init(from series: Series) {
        self.init(
            identifier: series.identifier,
            popularity: series.popularity,
            title: series.title,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear,
            thumbnail: series.thumbnail,
            charactersID: series.charactersID,
            nextIdentifier: series.nextIdentifier
        )
    }

}
