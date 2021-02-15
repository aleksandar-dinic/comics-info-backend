//
//  LambdaUpdateHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import protocol NIO.EventLoop

enum LambdaUpdateHandlerFactory {

    static func makeHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let updateResponseWrapper = SeriesUpdateResponseWrapper(seriesUseCase: useCaseFactory.makeUseCase())

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    private static func makeUseCaseFactory(on eventLoop: EventLoop) -> SeriesUpdateUseCaseFactory {
        SeriesUpdateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }

}
