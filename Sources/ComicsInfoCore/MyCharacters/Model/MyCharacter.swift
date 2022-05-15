//
//  MyCharacter.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 16/01/2022.
//

import struct Domain.MyCharacter
import struct Domain.SeriesSummary
import Foundation

struct MyCharacter: Codable {
    
    let userID: String
    let characterID: String
    private(set) var popularity: Int
    private(set) var name: String
    private let dateAdded: Date
    private var dateLastUpdated: Date
    private(set) var thumbnail: String?
    private(set) var description: String?
    private(set) var realName: String?
    private(set) var aliases: [String]?
    private(set) var birth: Date?
    private(set) var mySeries: [MySeriesSummary]?
    
    let itemID: String
    private let itemType: String
    private var sortValue: String
    
    mutating func update(with newCharacter: MyCharacter) {
        dateLastUpdated = Date()
        
        popularity = newCharacter.popularity
        name = newCharacter.name
        sortValue = newCharacter.sortValue
        
        if newCharacter.thumbnail != nil {
            thumbnail = newCharacter.thumbnail
        }
        if newCharacter.description != nil {
            description = newCharacter.description
        }
        if newCharacter.realName != nil {
            realName = newCharacter.realName
        }
        if let newAliases = newCharacter.aliases {
            var ans = Set(aliases ?? [])
            for alias in newAliases {
                ans.insert(alias)
            }
            aliases = Array(ans)
        }
        if newCharacter.birth != nil {
            birth = newCharacter.birth
        }
        
        if let newSeries = newCharacter.mySeries {
            var ids = Set(mySeries?.map { $0.identifier } ?? [])
            for series in newSeries where !ids.contains(series.identifier) {
                ids.insert(series.identifier)
                if mySeries != nil {
                    mySeries?.append(series)
                } else {
                    mySeries = [series]
                }
            }
        }
    }
    
}

extension MyCharacter {
    
    init(for userID: String, myCharacter: Domain.MyCharacter) {
        let now = Date()

        self.userID = userID
        characterID = myCharacter.identifier
        popularity = myCharacter.popularity
        name = myCharacter.name
        dateAdded = now
        dateLastUpdated = now
        thumbnail = myCharacter.thumbnail
        description = myCharacter.description
        realName = myCharacter.realName
        aliases = myCharacter.aliases
        birth = myCharacter.birth
        mySeries = myCharacter.mySeries?.map { MySeriesSummary(from: $0) }
        itemID = .comicInfoID(for: MyCharacter.self, ID: characterID)
        itemType = .getType(from: MyCharacter.self)
        sortValue = "Popularity=\(abs(popularity-100))#Name=\(name)"
    }
    
}

extension MyCharacter {
    
    static func make(
        userID: String = "UserID#1",
        characterID: String = "CharacterID#1",
        popularity: Int = 0,
        name: String = "MyCharacterName",
        dateAdded: Date = Date(),
        dateLastUpdated: Date = Date(),
        thumbnail: String? = "MyCharacter Thumbnail",
        description: String? = "MyCharacter Description",
        realName: String? = "MyCharacter RealName",
        aliases: [String] = ["MyCharacter Aliases"],
        birth: Date = Date(),
        mySeries: [MySeriesSummary] = [],
        itemID: String = "ItemID",
        itemType: String = "MyCharacter",
        sortValue: String = "Popularity=\(abs(0-100))#Name=MyCharacterName"
    ) -> MyCharacter {
        self.init(
            userID: userID,
            characterID: characterID,
            popularity: popularity,
            name: name,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            thumbnail: thumbnail,
            description: description,
            realName: realName,
            aliases: aliases,
            birth: birth,
            mySeries: mySeries,
            itemID: itemID,
            itemType: itemType,
            sortValue: sortValue
        )
    }
    
}
