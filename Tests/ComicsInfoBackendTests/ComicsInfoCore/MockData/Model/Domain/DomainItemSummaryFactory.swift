//
//  DomainItemSummaryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.ItemSummary
import Foundation

enum DomainItemSummaryFactory {
    
    static func make(
        identifier: String = "1",
        popularity: Int = 0,
        name: String = "ItemSummary Name",
        thumbnail: String? = "ItemSummary thumbnail",
        description: String? = "ItemSummary description",
        count: Int? = 0,
        number: String? = "ItemSummary number",
        roles: [String]? = ["ItemSummary roles"]
    ) -> Domain.ItemSummary {
        Domain.ItemSummary(
            identifier: identifier,
            popularity: popularity,
            name: name,
            thumbnail: thumbnail,
            description: description,
            count: count,
            number: number,
            roles: roles
        )
    }
    
}
