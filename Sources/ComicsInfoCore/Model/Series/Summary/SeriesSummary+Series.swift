//
//  SeriesSummary+Series.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension SeriesSummary {

    init<Summary: Identifiable>(_ series: Series, link: Summary) {
        self.init(
            ID: series.id,
            link: link,
            popularity: series.popularity,
            name: series.name,
            thumbnail: series.thumbnail,
            description: series.description,
            startYear: series.startYear,
            endYear: series.endYear
        )
    }
    
}
