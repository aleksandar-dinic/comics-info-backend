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
        let useCaseFactory = CharacterCreateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let createResponseWrapper = CharacterCreateResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    // Comic
    
    static func makeComicHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = ComicCreateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let createResponseWrapper = ComicCreateResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }

    // Series
    
    static func makeSeriesHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let seriesUseCaseFactory = SeriesCreateUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let createResponseWrapper = SeriesCreateResponseWrapper(useCase: seriesUseCaseFactory.makeUseCase())
        
        return CreateLambdaHandler(context, createResponseWrapper: createResponseWrapper)
    }
    
}
