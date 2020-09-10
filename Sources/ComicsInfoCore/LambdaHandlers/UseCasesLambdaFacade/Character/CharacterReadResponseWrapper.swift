//
//  CharacterReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import struct Domain.Character
import Foundation
import NIO

struct CharacterReadResponseWrapper: ErrorResponseWrapper {

    private let characterUseCase: CharacterUseCase

    init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    func handleRead(
        on eventLoop: EventLoop,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<Response> {
        guard let identifier = event.pathParameters?[.identifier] else {
            let response = Response(statusCode: .notFound)
            return eventLoop.makeSucceededFuture(response)
        }

        return characterUseCase.getCharacter(withID: identifier, fromDataSource: .database, on: eventLoop)
            .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapError { self.catchError(on: eventLoop, error: $0) }
    }

}
