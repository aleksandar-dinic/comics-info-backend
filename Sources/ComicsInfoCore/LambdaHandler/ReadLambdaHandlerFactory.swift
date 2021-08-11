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
        let useCaseFactory = makeCharacterUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = CharacterReadResponseWrapper(characterUseCase: useCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    private static func makeCharacterUseCaseFactory(on eventLoop: EventLoop) -> CharacterUseCaseFactory {
        CharacterUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.characterInMemoryCache
        )
    }
    
    // Comic
    
    static func makeComicReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeComicUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = ComicReadResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    private static func makeComicUseCaseFactory(on eventLoop: EventLoop) -> ComicUseCaseFactory {
        ComicUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.comicInMemoryCache
        )
    }
    
    // Series
    
    static func makeSeriesReadLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let readResponseWrapper = SeriesReadResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeUseCase())

        return ReadLambdaHandler(context, readResponseWrapper: readResponseWrapper)
    }

    private static func makeSeriesUseCaseFactory(on eventLoop: EventLoop) -> SeriesUseCaseFactory {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.seriesInMemoryCache
        )
    }


}
