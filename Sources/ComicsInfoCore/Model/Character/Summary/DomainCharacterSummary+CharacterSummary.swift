//
//  DomainCharacterSummary+CharacterSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.CharacterSummary
import Foundation

extension Domain.CharacterSummary {

    init(from summary: CharacterSummary) {
        self.init(
            identifier: summary.itemID.getIDFromComicInfoID(for: CharacterSummary.self),
            popularity: summary.popularity,
            name: summary.name,
            thumbnail: summary.thumbnail,
            description: summary.description,
            count: summary.count
        )
    }

}
