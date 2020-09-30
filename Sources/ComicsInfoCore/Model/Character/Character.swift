//
//  Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct Character: Codable, Identifiable {

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

    /// A resource list of seriesID in which this character appears.
    let seriesID: Set<String>?

    /// A resource list of series in which this character appears.
    let series: [Series]?

    /// A resource list containing comicsID which feature this character.
    let comicsID: Set<String>?

    /// A resource list containing comics which feature this character.
//    let comics: [Comic]?

}
