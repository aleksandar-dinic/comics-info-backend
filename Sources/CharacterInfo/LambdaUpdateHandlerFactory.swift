//
//  LambdaUpdateHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import struct Logging.Logger
import protocol NIO.EventLoop

enum LambdaUpdateHandlerFactory {

    static func makeHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUpdateUseCaseFactory(on: context.eventLoop, logger: context.logger)
        let updateResponseWrapper = CharacterUpdateResponseWrapper(
            characterUseCase: useCaseFactory.makeUseCase()
        )

        return UpdateLambdaHandler(context, updateResponseWrapper: updateResponseWrapper)
    }

    private static func makeUpdateUseCaseFactory(
        on eventLoop: EventLoop,
        logger: Logger
    ) -> CharacterUpdateUseCaseFactory {
        CharacterUpdateUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            logger: logger
        )
    }

}
