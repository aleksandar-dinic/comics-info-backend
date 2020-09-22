//
//  CharacterReadLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import NIO

struct CharacterReadLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    typealias In = Request
    typealias Out = APIGateway.V2.Response

    private let characterReadResponseWrapper: CharacterReadResponseWrapper

    init(context: Lambda.InitializationContext) {
        self.init(on: context.eventLoop, isLocalServer: LocalServer.isEnabled)
    }

    private init(on eventLoop: EventLoop, isLocalServer: Bool) {
        let characterUseCaseFactory = CharacterUseCaseFactory(on: eventLoop, isLocalServer: isLocalServer)
        characterReadResponseWrapper = CharacterReadResponseWrapper(characterUseCase: characterUseCaseFactory.makeCharacterUseCase())
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return characterReadResponseWrapper.handleRead(on: context.eventLoop, request: event)
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }

}
