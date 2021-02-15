//
//  LambdaCreateHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import protocol NIO.EventLoop

enum LambdaCreateHandlerFactory {

    static func makeHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let createResponseWrapper = SeriesCreateResponseWrapper(useCase: seriesUseCaseFactory.makeUseCase())
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    private static func makeUseCaseFactory(on eventLoop: EventLoop) -> SeriesCreateUseCaseFactory {
        SeriesCreateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }

}
