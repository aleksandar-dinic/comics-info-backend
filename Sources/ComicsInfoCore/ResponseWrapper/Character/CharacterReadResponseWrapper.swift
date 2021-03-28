//
//  CharacterReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterReadResponseWrapper: ReadResponseWrapper {

    private let characterUseCase: CharacterUseCase

    public init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }
        
        let fields = getFields(from: request.queryParameters)

        let table = String.tableName(for: environment)
        return characterUseCase.getItem(on: eventLoop, withID: id, fields: fields, from: table, logger: logger)
            .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }
    
}
