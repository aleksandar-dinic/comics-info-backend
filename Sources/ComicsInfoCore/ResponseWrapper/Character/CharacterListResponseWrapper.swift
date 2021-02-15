//
//  CharacterListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterListResponseWrapper: ListResponseWrapper {

    private let characterUseCase: CharacterUseCase

    public init(characterUseCase: CharacterUseCase) {
        self.characterUseCase = characterUseCase
    }

    public func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        let fields = getFields(from: request.queryParameters)
        
        return characterUseCase.getAllItems(on: eventLoop, fields: fields, from: table, logger: logger)
            .map { Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }

}
