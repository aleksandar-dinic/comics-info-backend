//
//  LambdaDeleteHandlerFactory.swift
//  ComicInfo
//
//  Created by Aleksandar Dinic on 23/05/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import protocol NIO.EventLoop

enum LambdaDeleteHandlerFactory {

    static func makeHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeDeleteUseCaseFactory(on: context.eventLoop)
        let deleteResponseWrapper = ComicDeleteResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )

        return DeleteLambdaHandler(context, deleteResponseWrapper: deleteResponseWrapper)
    }

    private static func makeDeleteUseCaseFactory(on eventLoop: EventLoop) -> ComicDeleteUseCaseFactory {
        ComicDeleteUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
    }

}
