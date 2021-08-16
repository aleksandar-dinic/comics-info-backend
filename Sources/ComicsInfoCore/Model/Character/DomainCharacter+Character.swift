//
//  DomainCharacter+Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Domain.SeriesSummary
import struct Domain.ComicSummary
import Foundation

extension Domain.Character {

    init(from character: Character) {
        let series = character.series?.map { Domain.SeriesSummary(from: $0) }
        let comics = character.comics?.map { Domain.ComicSummary(from: $0) }

        self.init(
            identifier: character.id,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            realName: character.realName,
            aliases: character.aliases,
            birth: character.birth,
            series: series?.sorted(by: { $0.popularity > $1.popularity }),
            comics: comics?.sorted(by: { $0.popularity > $1.popularity })
        )
    }

}
