//
//  CharacterCreateResponseWrapper.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 19/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import ComicsInfoCore
import Foundation
import NIO

struct CharacterCreateResponseWrapper: ErrorResponseWrapper {

    private let characterUseCase: CharacterUseCase

    init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    func handleCreate(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        do {
            let character = try JSONDecoder().decode(Character.self, from: data)
            return characterUseCase.create(character)
                .map { Response(with: CharacterCreated(), statusCode: .created) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: error, statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
