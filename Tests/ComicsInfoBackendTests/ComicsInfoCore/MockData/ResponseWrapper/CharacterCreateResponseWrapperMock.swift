//
//  CharacterCreateResponseWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 21/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

enum CharacterCreateResponseWrapperMock {

    typealias Cache = InMemoryCacheProvider<Character>
    typealias UseCase = CharacterUseCase<CharacterRepositoryAPIWrapper, Cache>

    static func make(on eventLoop: EventLoop) -> CreateResponseWrapper<UseCase> {
        CreateResponseWrapper(useCase: CharacterUseCaseFactoryMock(on: eventLoop).makeUseCase())
    }

}
