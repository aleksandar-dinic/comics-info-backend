//
//  CharacterCreateResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation
import NIO

public struct CharacterCreateResponseWrapper<APIWrapper: CreateRepositoryAPIWrapper>: CreateResponseWrapper where APIWrapper.Item == Character {

    private let useCase: CharacterCreateUseCase<APIWrapper>

    public init(useCase: CharacterCreateUseCase<APIWrapper>) {
        self.useCase = useCase
    }

    public func handleCreate(
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
            return useCase.create(Character(from: item), on: eventLoop, in: table)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) created"), statusCode: .created) }
                .flatMapErrorThrowing { self.catch($0, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
