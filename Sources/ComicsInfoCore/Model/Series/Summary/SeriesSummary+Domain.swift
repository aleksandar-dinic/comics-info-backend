//
//  SeriesSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.SeriesSummary
import Foundation

extension SeriesSummary {
    
    init<Summary: Identifiable>(from seriesSummary: Domain.SeriesSummary, link: Summary) {
        self.init(
            ID: seriesSummary.identifier,
            link: link,
            popularity: seriesSummary.popularity,
            name: seriesSummary.title,
            thumbnail: seriesSummary.thumbnail,
            description: seriesSummary.description,
            startYear: seriesSummary.startYear,
            endYear: seriesSummary.endYear
        )
    }
    
}
