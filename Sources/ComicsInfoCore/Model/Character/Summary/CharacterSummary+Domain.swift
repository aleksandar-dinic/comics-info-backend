//
//  CharacterSummary+Domain.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension CharacterSummary {
    
    init<Summary: Identifiable>(from item: Domain.ItemSummary, link: Summary, count: Int?) {
        self.init(
            ID: item.identifier,
            link: link,
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: count
        )
    }
    
}
