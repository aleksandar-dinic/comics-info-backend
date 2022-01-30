//
//  CharacterUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import struct Logging.Logger
import Foundation
import NIO

public struct CharacterUpdateResponseWrapper: UpdateResponseWrapper {

    private let characterUseCase: CharacterUpdateUseCase

    public init(characterUseCase: CharacterUpdateUseCase) {
        self.characterUseCase = characterUseCase
    }

    public func handleUpdate(
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
            let character = Character(from: item)
            let criteria = UpdateItemCriteria(
                item: character,
                oldSortValue: character.sortValue,
                on: eventLoop,
                in: table,
                log: logger
            )
            return characterUseCase.update(with: criteria)
                .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseMessage(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.submit { response }
        }
    }

}
