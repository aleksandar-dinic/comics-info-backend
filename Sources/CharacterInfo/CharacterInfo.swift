//
//  CharacterInfo.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation
import NIO

public final class CharacterInfo {

    static let characterInMemoryCache = InMemoryCacheProvider<Character>()

    private let localServer: LocalServer

    public init(localServer: LocalServer = LocalServer()) {
        self.localServer = localServer
    }

    public func run(handler: Handler? = Handler(rawValue: Lambda.handler)) throws {
        switch handler {
        case .read:
            Lambda.run {
                LambdaHandlerFactory.makeReadLambdaHandler($0)
            }

        case .list:
            Lambda.run {
                LambdaHandlerFactory.makeListLambdaHandler($0)
            }

        case .create:
            Lambda.run {
                LambdaHandlerFactory.makeCreateLambdaHandler($0)
            }

        case .update, .delete, .none:
            throw APIError.handlerUnknown
        }
    }

}
