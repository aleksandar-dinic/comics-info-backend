//
//  CharacterDecoderService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol CharacterDecoderService {

    func decodeAllCharacters(from items: [[String: Any]]?) throws -> [Character]

    func decodeCharacter(from items: [String: Any]?) throws -> Character

}
