//
//  LambdaHandlerFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import protocol NIO.EventLoop

enum LambdaHandlerFactory {

    static func makeReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = CharacterReadResponseWrapper(characterUseCase: useCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    static func makeListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = CharacterListResponseWrapper(characterUseCase: useCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
    }

    private static func makeUseCaseFactory(on eventLoop: EventLoop) -> CharacterUseCaseFactory {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: CharacterInfo.characterInMemoryCache
        )
    }

}
