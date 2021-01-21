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
            dateAdded: item.dateAdded,
            dateLastUpdated: item.dateLastUpdated,
            thumbnail: item.thumbnail,
            description: item.description,
            realName: item.realName,
            aliases: item.aliases,
            birth: item.birth,
            seriesID: item.getSeriesID(),
            series: item.seriesSummary,
            comicsID: item.getComicsID(),
            comics: item.comicsSummary
        )
    }

}
