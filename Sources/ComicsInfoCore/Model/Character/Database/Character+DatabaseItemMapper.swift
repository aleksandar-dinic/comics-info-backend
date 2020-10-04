//
//  Character+DatabaseItemMapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Character: DatabaseItemMapper {

    init(from item: CharacterDatabase) {
        self.init(
            id: item.id,
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            seriesID: item.getSeriesID(),
            series: item.seriesSummary?.compactMap { Series(fromSummary: $0) },
            comicsID: item.getComicsID()
        )
    }

}
