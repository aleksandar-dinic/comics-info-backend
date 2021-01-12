//
//  Character+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 28/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Domain
import Foundation

extension Domain.Character {

    init(from character: Character) {
        let series = character.series?.compactMap { Domain.Series(from: $0) }
        let comics = character.comics?.compactMap { Domain.Comic(from: $0) }

        self.init(
            identifier: character.id,
            popularity: character.popularity,
            name: character.name,
            thumbnail: character.thumbnail,
            description: character.description,
            realName: character.realName,
            aliases: character.aliases,
            birth: character.birth,
            series: series?.sorted(by: { $0.popularity < $1.popularity }),
            comics: comics?.sorted(by: { $0.popularity < $1.popularity })
        )
    }

}
