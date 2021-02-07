//
//  DomainItemSummary+ComicSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

extension Domain.ItemSummary {

    init<Item>(from item: ComicSummary<Item>) {
        self.init(
            identifier: item.itemID.replacingOccurrences(of: "\(String.getType(from: Comic.self))#", with: ""),
            popularity: item.popularity,
            name: item.name,
            thumbnail: item.thumbnail,
            description: item.description,
            count: nil,
            number: item.number,
            roles: nil)
    }

}
