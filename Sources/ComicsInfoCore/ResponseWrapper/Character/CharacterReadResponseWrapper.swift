//
//  CharacterReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation
import NIO

public struct CharacterReadResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ReadResponseWrapper where APIWrapper.Item == Character, CacheProvider.Item == Character {

    private let characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>

    public init(characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>) {
        self.characterUseCase = characterUseCase
    }

    public func handleRead(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        guard let id = request.pathParameters?["id"] else {
            let response = Response(statusCode: .badRequest)
            return eventLoop.makeSucceededFuture(response)
        }

        return characterUseCase.getItem(withID: id, fromDataSource: .memory)
            .map { Response(with: Domain.Character(from: $0), statusCode: .ok) }
            .flatMapError { self.catch($0, on: eventLoop) }
    }

}
