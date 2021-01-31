//
//  CharacterListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Character
import Foundation
import NIO

public struct CharacterListResponseWrapper<APIWrapper: RepositoryAPIWrapper, CacheProvider: Cacheable>: ListResponseWrapper where APIWrapper.Item == Character, CacheProvider.Item == Character {

    private let characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>

    public init(characterUseCase: CharacterUseCase<APIWrapper, CacheProvider>) {
        self.characterUseCase = characterUseCase
    }

    public func handleList(on eventLoop: EventLoop, environment: String?) -> EventLoopFuture<Response> {
        let table = String.tableName(for: environment)
        return characterUseCase.getAllItems(on: eventLoop, from: table)
            .map { Response(with: $0.map { Domain.Character(from: $0) }, statusCode: .ok) }
            .flatMapErrorThrowing { self.catch($0) }
    }

}
