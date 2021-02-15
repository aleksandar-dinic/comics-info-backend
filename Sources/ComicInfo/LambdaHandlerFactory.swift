//
//  LambdaHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import protocol NIO.EventLoop

enum LambdaHandlerFactory {

    static func makeReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = ComicReadResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    static func makeListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = ComicListResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
    }

    private static func makeUseCaseFactory(on eventLoop: EventLoop) -> ComicUseCaseFactory {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicInfo.comicInMemoryCache
        )
    }

}
