//
//  CharacterAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 01/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterAPIWrapper {

    private let characterAPIService: CharacterAPIService
    private let characterDecoderService: CharacterDecoderService

    init(
        characterAPIService: CharacterAPIService,
        characterDecoderService: CharacterDecoderService
    ) {
        self.characterAPIService = characterAPIService
        self.characterDecoderService = characterDecoderService
    }

    func getAllCharacters(on eventLoop: EventLoop) -> EventLoopFuture<[Character]> {
        characterAPIService.getAllCharacters(on: eventLoop).flatMapThrowing {
            try characterDecoderService.decodeAllCharacters(from: $0)
        }
    }

    func getCharacter(
        withID characterID: String,
        on eventLoop: EventLoop
    ) -> EventLoopFuture<Character> {
        characterAPIService.getCharacter(withID: characterID, on: eventLoop).flatMapThrowing {
            try characterDecoderService.decodeCharacter(from: $0)
        }
    }
    
}
