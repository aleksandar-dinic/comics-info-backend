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

    typealias UseCase = CharacterCreateUseCase<CharacterCreateRepositoryAPIWrapper>

    static func make(on eventLoop: EventLoop) -> ComicsInfoCore.CreateResponseWrapper<UseCase> {
        ComicsInfoCore.CreateResponseWrapper(useCase: CharacterCreateUseCaseFactoryMock(on: eventLoop).makeUseCase())
    }

}
