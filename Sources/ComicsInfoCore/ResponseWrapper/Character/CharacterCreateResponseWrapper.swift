//
//  CharacterCreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterCreateResponseWrapper: CreateResponseWrapper {

    private let useCase: CharacterCreateUseCase

    public init(useCase: CharacterCreateUseCase) {
        self.useCase = useCase
    }

    public func handleCreate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.submit { response }
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Character.self, from: data)
            let criteria = CreateItemCriteria(item: Character(from: item), on: eventLoop, in: table, log: logger)
            return useCase.create(with: criteria)
                .map { Response(with: Domain.Character(from: $0), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseMessage(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.submit { response }
        }
    }

}
