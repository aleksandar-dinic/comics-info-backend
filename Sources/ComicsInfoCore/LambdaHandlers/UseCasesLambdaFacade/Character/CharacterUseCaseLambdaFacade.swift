//
//  CharacterUseCaseLambdaFacade.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 09/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

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
        request: Request
    ) -> EventLoopFuture<Response> {
        CharacterReadResponseWrapper(characterUseCase: characterUseCase)
            .handleRead(on: eventLoop, request: request)
    }

    func handleList(on eventLoop: EventLoop) -> EventLoopFuture<Response> {
        CharacterListResponseWrapper(characterUseCase: characterUseCase)
            .handleList(on: eventLoop)
    }

}

