//
//  CharacterUseCaseLambdaFacade.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import Foundation
import NIO

struct CharacterUseCaseLambdaFacade {

    private let characterUseCase: CharacterUseCase

    init(action: HandlerAction, characterAPIService: CharacterAPIService) {
        let characterRepositoryFactory = CharacterRepositoryFactory(
            characterAPIService: characterAPIService
        )
        characterUseCase = CharacterUseCase(characterRepository: characterRepositoryFactory.makeCharacterRepository())
    }

    func handleRead(
        on eventLoop: EventLoop,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        CharacterReadResponseWrapper(characterUseCase: characterUseCase)
            .handleRead(on: eventLoop, request: Request(from: event))
            .map { APIGateway.V2.Response(with: $0) }
    }

    func handleList(
        on eventLoop: EventLoop,
        event: APIGateway.V2.Request
    ) -> EventLoopFuture<APIGateway.V2.Response> {
        CharacterListResponseWrapper(characterUseCase: characterUseCase)
            .handleList(on: eventLoop)
            .map { APIGateway.V2.Response(with: $0) }
    }

}

