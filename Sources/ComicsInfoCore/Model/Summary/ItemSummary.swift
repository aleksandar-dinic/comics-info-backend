//
//  ItemSummary.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 21/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct ItemSummary<Item: SummaryMapper>: Codable, DatabaseItemSummary {

    let id: String
    let itemID: String
    let summaryID: String
    let itemName: String
    let summaryName: String

    var popularity: Int
    var name: String
    let dateAdded: Date
    let dateLastUpdated: Date
    var thumbnail: String?
    var description: String?
    let count: Int?
    let number: String?
    let roles: [String]?

    mutating func update(with item: Item) {
        popularity = item.popularity
        name = item.name

        if let thumbnail = item.thumbnail {
            self.thumbnail = thumbnail
        }

        if let description = item.description {
            self.description = description
        }
    }

    func shouldBeUpdated(with item: Item) -> Bool {
        popularity != item.popularity ||
            name != item.name ||
            thumbnail != item.thumbnail ||
            description != item.description
    }

}

extension ItemSummary {
    
    init(_ item: Item, id: String, itemName: String) {
        self.init(item, id: id, itemName: itemName, count: nil, number: nil, roles: nil)
    }

    init(_ item: Item, id: String, itemName: String, count: Int?, number: String?, roles: [String]?) {
        self.id = "\(item.id)"
        itemID = "\(itemName)#\(id)"
        summaryID = "\(String.getType(from: Item.self))#\(item.id)"
        self.itemName = itemName
        summaryName = .getType(from: Item.self)
        popularity = item.popularity
        name = item.name
        dateAdded = Date()
        dateLastUpdated = Date()
        description = item.description
        thumbnail = item.thumbnail
        self.count = count
        self.number = number
        self.roles = roles
    }

}

extension ItemSummary {

    enum CodingKeys: String, CodingKey {
        case id
        case itemID
        case summaryID
        case itemName
        case summaryName
        case popularity
        case name
        case dateAdded
        case dateLastUpdated
        case thumbnail
        case description
        case count
        case number
        case roles
    }

    public init(from item: DatabaseItem) throws {
        let decoder = DatabaseDecoder(from: item)

        itemID = try decoder.decode(String.self, forKey: CodingKeys.itemID)
        summaryID = try decoder.decode(String.self, forKey: CodingKeys.summaryID)
        guard summaryID.starts(with: "\(String.getType(from: Item.self))#") else {
            throw APIError.invalidSummaryID(summaryID, itemType: .getType(from: Item.self))
        }
        id = String(summaryID.dropFirst("\(String.getType(from: Item.self))#".count))

        itemName = try decoder.decode(String.self, forKey: CodingKeys.itemName)
        summaryName = try decoder.decode(String.self, forKey: CodingKeys.summaryName)
        popularity = try decoder.decode(Int.self, forKey: CodingKeys.popularity)
        name = try decoder.decode(String.self, forKey: CodingKeys.name)
        dateAdded = try decoder.decode(Date.self, forKey: CodingKeys.dateAdded)
        dateLastUpdated = try decoder.decode(Date.self, forKey: CodingKeys.dateLastUpdated)
        thumbnail = try? decoder.decode(String.self, forKey: CodingKeys.thumbnail)
        description = try? decoder.decode(String.self, forKey: CodingKeys.description)
        count = try? decoder.decode(Int.self, forKey: CodingKeys.count)
        number = try? decoder.decode(String.self, forKey: CodingKeys.number)
        roles = try? decoder.decode([String].self, forKey: CodingKeys.roles)
    }

}
