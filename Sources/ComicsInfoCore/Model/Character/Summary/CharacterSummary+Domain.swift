//
//  CharacterSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.CharacterSummary
import Foundation

extension CharacterSummary {
    
    init<Summary: Identifiable>(from characterSummary: Domain.CharacterSummary, link: Summary, count: Int?) {
        self.init(
            ID: characterSummary.identifier,
            link: link,
            popularity: characterSummary.popularity,
            name: characterSummary.name,
            thumbnail: characterSummary.thumbnail,
            description: characterSummary.description,
            count: count
        )
    }
    
}
