//
//  CharacterUpdateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation
import NIO

public struct CharacterUpdateResponseWrapper<APIWrapper: UpdateRepositoryAPIWrapper>: UpdateResponseWrapper where APIWrapper.Item == Character {

    private let characterUseCase: CharacterUpdateUseCase<APIWrapper>

    public init(characterUseCase: CharacterUpdateUseCase<APIWrapper>) {
        self.characterUseCase = characterUseCase
    }

    public func handleUpdate(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        let table = String.tableName(for: environment)
        do {
            let item = try JSONDecoder().decode(Domain.Character.self, from: data)
            return characterUseCase.update(Character(from: item), on: eventLoop, in: table)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) updated"), statusCode: .ok) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
