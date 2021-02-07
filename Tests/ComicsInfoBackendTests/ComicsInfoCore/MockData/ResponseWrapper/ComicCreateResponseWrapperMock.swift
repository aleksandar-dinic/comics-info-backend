//
//  ComicCreateResponseWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

enum ComicCreateResponseWrapperMock {

    typealias UseCase = ComicCreateUseCase

    static func make(
        on eventLoop: EventLoop
    ) -> ComicCreateResponseWrapper {
        ComicCreateResponseWrapper(
            useCase: ComicCreateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        )
    }

}
