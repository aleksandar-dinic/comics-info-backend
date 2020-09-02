//
//  CharacterCacheService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

protocol CharacterCacheService {

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[Character]>

    func getCharacter(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character>

    func save(characters: [Character])

}
