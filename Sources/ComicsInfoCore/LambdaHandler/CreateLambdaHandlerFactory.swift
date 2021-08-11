//
//  CreateLambdaHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import protocol NIO.EventLoop

enum CreateLambdaHandlerFactory {
    
    // Character

    static func makeCharacterHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeCharacterUseCaseFactory(on: context.eventLoop)
        let createResponseWrapper = CharacterCreateResponseWrapper(useCase: useCaseFactory.makeUseCase())
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    private static func makeCharacterUseCaseFactory(on eventLoop: EventLoop) -> CharacterCreateUseCaseFactory {
        CharacterCreateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }

    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = makeComicUseCaseFactory(on: context.eventLoop)
        let createResponseWrapper = ComicCreateResponseWrapper(useCase: useCaseFactory.makeUseCase())
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    private static func makeComicUseCaseFactory(on eventLoop: EventLoop) -> ComicCreateUseCaseFactory {
        ComicCreateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }
    
    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = makeSeriesUseCaseFactory(on: context.eventLoop)
        let createResponseWrapper = SeriesCreateResponseWrapper(useCase: seriesUseCaseFactory.makeUseCase())
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    private static func makeSeriesUseCaseFactory(on eventLoop: EventLoop) -> SeriesCreateUseCaseFactory {
        SeriesCreateUseCaseFactory(on: eventLoop, isLocalServer: LocalServer.isEnabled)
    }
    
}
