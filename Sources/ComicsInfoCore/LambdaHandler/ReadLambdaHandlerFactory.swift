//
//  ReadLambdaHandlerFactory.swift
//  CharacterInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import protocol NIO.EventLoop

enum ReadLambdaHandlerFactory {
    
    // Character

    static func makeCharacterReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = CharacterUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.characterInMemoryCache
        )
        let readResponseWrapper = CharacterReadResponseWrapper(
            characterUseCase: useCaseFactory.makeUseCase()
        )

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    // Comic
    
    static func makeComicReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = ComicUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.comicInMemoryCache
        )
        let readResponseWrapper = ComicReadResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    // Series
    
    static func makeSeriesReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = SeriesUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.seriesInMemoryCache
        )
        let readResponseWrapper = SeriesReadResponseWrapper(
            seriesUseCase: seriesUseCaseFactory.makeUseCase()
        )

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

}
