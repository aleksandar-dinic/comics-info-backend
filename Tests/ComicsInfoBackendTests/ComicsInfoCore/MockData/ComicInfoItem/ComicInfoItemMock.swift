//
//  ComicInfoItemMock.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation

struct ComicInfoItemMock: ComicInfoItem {

    let id: String
    let itemID: String
    let summaryID: String
    let itemName: String
    
    let popularity: Int
    let name: String
    
}
