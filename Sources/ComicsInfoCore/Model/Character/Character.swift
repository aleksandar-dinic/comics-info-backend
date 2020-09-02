//
//  Character.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct Character: Codable {

    /// The unique ID of the character resource.
    let identifier: String

    /// The value of character popularity
    let popularity: Int

    /// The name of the character.
    let name: String

    /// The representative image for this character.
    let thumbnail: String?

    ///  A short bio or description of the character
    let description: String?

}
