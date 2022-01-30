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
    let popularity: Int
    let name: String
    private let dateAdded: Date
    private let dateLastUpdated: Date
    let thumbnail: String?
    let description: String?
    let realName: String?
    let aliases: [String]?
    let birth: Date?
    let mySeries: [MySeriesSummary]?
    
    let itemID: String
    private let itemType: String
    private let sortValue: String
    
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
