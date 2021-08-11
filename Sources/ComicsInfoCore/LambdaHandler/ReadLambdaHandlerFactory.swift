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

    static func makeCharacterListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeCharacterUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = CharacterListResponseWrapper(characterUseCase: useCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
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

    static func makeComicListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeComicUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = ComicListResponseWrapper(comicUseCase: useCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
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

    static func makeSeriesListLambdaHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let listResponseWrapper = SeriesListResponseWrapper(seriesUseCase: seriesUseCaseFactory.makeUseCase())

        return ListLambdaHandler(context, listResponseWrapper: listResponseWrapper)
    }

    private static func makeSeriesUseCaseFactory(on eventLoop: EventLoop) -> SeriesUseCaseFactory {
        SeriesUseCaseFactory(
            on: eventLoop,
            isLocalServer: LocalServer.isEnabled,
            cacheProvider: ComicsInfo.seriesInMemoryCache
        )
    }


}
