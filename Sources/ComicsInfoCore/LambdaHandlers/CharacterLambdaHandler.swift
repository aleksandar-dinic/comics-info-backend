//
//  CharacterLambdaHandler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterLambdaHandler {

    private let action: HandlerAction
    private let characterUseCaseLambdaFacade: CharacterUseCaseLambdaFacade

    init(action: HandlerAction, characterAPIService: CharacterAPIService) {
        self.action = action
        characterUseCaseLambdaFacade = CharacterUseCaseLambdaFacade(action: action, characterAPIService: characterAPIService)
    }

    func handle(
        on eventLoop: EventLoop,
        request: Request
    ) -> EventLoopFuture<Response> {
        switch action {
        case .create, .update, .delete:
            let response = Response(statusCode: .notFound)
            return eventLoop.makeSucceededFuture(response)

        case .read:
            return characterUseCaseLambdaFacade.handleRead(on: eventLoop, request: request)
        case .list:
            return characterUseCaseLambdaFacade.handleList(on: eventLoop)
        }
    }

}
