//
//  CharacterCreated.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterCreated: Codable {

    let message: String

    init(message: String = "Character created") {
        self.message = message
    }

}
