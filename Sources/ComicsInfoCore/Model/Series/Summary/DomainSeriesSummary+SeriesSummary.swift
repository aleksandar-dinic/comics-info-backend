//
//  DomainSeriesSummary+SeriesSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.SeriesSummary
import Foundation

extension Domain.SeriesSummary {

    init(from seriesSummary: SeriesSummary) {
        self.init(
            identifier: seriesSummary.itemID.getIDFromComicInfoID(for: SeriesSummary.self),
            popularity: seriesSummary.popularity,
            title: seriesSummary.name,
            thumbnail: seriesSummary.thumbnail,
            description: seriesSummary.description,
            startYear: seriesSummary.startYear,
            endYear: seriesSummary.endYear
        )
    }

}
