//
//  FeedbackLambdaHandlerFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation
import protocol NIO.EventLoop

enum FeedbackLambdaHandlerFactory {
    
    static func makeHandler(_ context: Lambda.InitializationContext) -> Lambda.Handler {
        let useCaseFactory = FeedbackUseCaseFactory(
            on: context.eventLoop,
            isLocalServer: LocalServer.isEnabled
        )
        let responseWrapper = FeedbackResponseWrapper(
            useCase: useCaseFactory.makeUseCase()
        )
        
        return FeedbackLambdaHandler(context, responseWrapper: responseWrapper)
    }
    
}
