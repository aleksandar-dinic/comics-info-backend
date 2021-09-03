//
//  ComicsInfo.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 11/08/2021.
//  Copyright © 2021s Aleksandar Dinic. All rights reserved.
//

import Foundation
import enum AWSLambdaRuntime.Lambda

public final class ComicsInfo {

    private let localServer: LocalServer

    public init(localServer: LocalServer = LocalServer()) {
        self.localServer = localServer
    }

    public func run(handler: Handler? = Handler(for: Lambda.handler)) throws {
        switch handler {
        case let .character(operation):
            handleCharacter(for: operation)

        case let .series(operation):
            handleSeries(for: operation)
            
        case let .comic(operation):
            handleComic(for: operation)
            
        case let .feedback(operation):
            try handleFeedback(for: operation)
            
        case .none:
            throw ComicInfoError.handlerUnknown
        }
    }
    
    private func handleCharacter(for operation: CRUDOperation) {
        switch operation {
        case .create:
            Lambda.run { CreateLambdaHandlerFactory.makeCharacterHandler($0) }
            
        case .read:
            Lambda.run { ReadLambdaHandlerFactory.makeCharacterReadLambdaHandler($0) }

        case .update:
            Lambda.run { UpdateLambdaHandlerFactory.makeCharacterHandler($0) }

        case .delete:
            Lambda.run { DeleteLambdaHandlerFactory.makeCharacterHandler($0) }
        }
    }
    
    private func handleSeries(for operation: CRUDOperation) {
        switch operation {
        case .create:
            Lambda.run { CreateLambdaHandlerFactory.makeSeriesHandler($0) }
            
        case .read:
            Lambda.run { ReadLambdaHandlerFactory.makeSeriesReadLambdaHandler($0) }

        case .update:
            Lambda.run { UpdateLambdaHandlerFactory.makeSeriesHandler($0) }

        case .delete:
            Lambda.run { DeleteLambdaHandlerFactory.makeSeriesHandler($0) }
        }
    }
    
    private func handleComic(for operation: CRUDOperation) {
        switch operation {
        case .create:
            Lambda.run { CreateLambdaHandlerFactory.makeComicHandler($0) }
            
        case .read:
            Lambda.run { ReadLambdaHandlerFactory.makeComicReadLambdaHandler($0) }

        case .update:
            Lambda.run { UpdateLambdaHandlerFactory.makeComicHandler($0) }

        case .delete:
            Lambda.run { DeleteLambdaHandlerFactory.makeComicHandler($0) }
        }
    }
    
    private func handleFeedback(for operation: CRUDOperation) throws {
        switch operation {
        case .create:
            Lambda.run { FeedbackLambdaHandlerFactory.makeHandler($0) }
            
        default:
            throw ComicInfoError.handlerUnknown
        }
    }

}
