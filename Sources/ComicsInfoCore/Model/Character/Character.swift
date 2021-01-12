//
//  Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Character: ComicsInfoItem {

    /// The unique ID of the character resource.
    public let id: String

    /// The value of character popularity
    let popularity: Int

    /// The name of the character.
    let name: String

    /// The representative image for this character.
    let thumbnail: String?

    ///  A short bio or description of the character
    let description: String?
    
    /// Real name of the character.
    let realName: String?
    
    /// List of aliases the character is known by.
    let aliases: [String]?
    
    /// A date, that the character was born on. Not an origin date.
    let birth: Date?

    /// A resource list of seriesID in which this character appears.
    var seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    let series: [Series]?

    /// A resource list containing comicsID which feature this character.
    var comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
    let comics: [Comic]?

    mutating func removeID(_ itemID: String) {
        if itemID.starts(with: String.getType(from: Series.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Series.self))#".count)
            seriesID?.remove(String(id))
        } else if itemID.starts(with: String.getType(from: Comic.self)) {
            let id = itemID.dropFirst("\(String.getType(from: Comic.self))#".count)
            comicsID?.remove(String(id))
        }
    }

}
