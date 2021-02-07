//
//  SeriesCreateResponseWrapperMock.swift
//  ComicsInfoBackendTests
//
//  Created by Aleksandar Dinic on 24/01/2021.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

@testable import ComicsInfoCore
import Foundation
import NIO

enum SeriesCreateResponseWrapperMock {

    typealias UseCase = SeriesCreateUseCase

    static func make(
        on eventLoop: EventLoop
    ) -> SeriesCreateResponseWrapper {
        SeriesCreateResponseWrapper(
            useCase: SeriesCreateUseCaseFactoryMock(on: eventLoop).makeUseCase()
        )
    }

}
