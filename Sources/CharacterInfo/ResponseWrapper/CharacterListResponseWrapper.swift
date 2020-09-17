//
//  CharacterListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import ComicsInfoCore
import Foundation
import NIO

struct CharacterListResponseWrapper: ErrorResponseWrapper {

    private let characterUseCase: CharacterUseCase

    init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response> {
        characterUseCase.getAllCharacters(fromDataSource: .memory, on: eventLoop)
            .map { Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
            .flatMapError { self.catchError(on: eventLoop, error: $0) }
    }

}
