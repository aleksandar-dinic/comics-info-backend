//
//  CharacterListLambdaHandler.swift
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

struct CharacterListLambdaHandler: EventLoopLambdaHandler, LoggerProvider {

    typealias In = Request
    typealias Out = APIGateway.V2.Response

    private let characterListResponseWrapper: CharacterListResponseWrapper

    init(context: Lambda.InitializationContext) {
        let characterUseCaseFactory = CharacterUseCaseFactory(on: context.eventLoop)
        characterListResponseWrapper = CharacterListResponseWrapper(characterUseCase: characterUseCaseFactory.makeCharacterUseCase())
    }

    func handle(
        context: Lambda.Context,
        event: Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        logRequest(context.logger, request: event)

        return characterListResponseWrapper.handleList(on: context.eventLoop)
            .map { APIGateway.V2.Response(from: $0) }
            .always { logResponse(context.logger, response: $0) }
    }

}
