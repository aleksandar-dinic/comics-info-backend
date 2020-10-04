//
//  Series+DatabaseItemMapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

extension Series: DatabaseItemMapper  {

    init(from item: SeriesDatabase)  {
        self.init(
            id: item.id,
            popularity: item.popularity,
            title: item.title,
            thumbnail: item.thumbnail,
            description: item.description,
            startYear: item.startYear,
            endYear: item.endYear,
            nextIdentifier: item.nextIdentifier,
            charactersID: item.getCharactersID(),
            characters: item.charactersSummary?.compactMap { Character(fromSummary: $0) },
            comicsID: item.getComicsID()
        )
    }

}
