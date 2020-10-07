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

public struct CharacterUpdateResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: UpdateResponseWrapper where APIWrapper.Item == Character, CacheProvider.Item == Character {

    private let characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>

    public init(characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>) {
        self.characterUseCase = characterUseCase
    }

    public func handleUpdate(on eventLoop: EventLoop, request: Request) -> EventLoopFuture<Response> {
        guard let data = request.body?.data(using: .utf8) else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        do {
            let item = try JSONDecoder().decode(Character.self, from: data)
            return characterUseCase.update(item)
                .map { Response(with: ResponseStatus("\(type(of: item.self)) updated"), statusCode: .ok) }
                .flatMapError { self.catch($0, on: eventLoop, statusCode: .forbidden) }

        } catch {
            let response = Response(with: ResponseStatus(error.localizedDescription), statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }
    }

}
