//
//  ItemSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public protocol ItemSummary: Codable {
    
    var itemID: String { get }
    var summaryID: String { get }
    var itemName: String { get }
    
    var dateAdded: Date { get }
    var dateLastUpdated: Date { get }
    var popularity: Int { get }
    var name: String { get }
    var thumbnail: String? { get }
    var description: String? { get }
    
}
