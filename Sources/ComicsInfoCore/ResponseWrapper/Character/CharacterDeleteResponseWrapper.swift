//
//  CharacterDeleteResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 29/04/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterDeleteResponseWrapper: DeleteResponseWrapper {

    private let useCase: CharacterDeleteUseCase

    public init(useCase: CharacterDeleteUseCase) {
        self.useCase = useCase
    }

    public func handleDelete(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }
        
        let table = String.tableName(for: environment)
        return useCase.delete(withID: id, on: eventLoop, from: table, logger: logger)
            .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }
    }

}
