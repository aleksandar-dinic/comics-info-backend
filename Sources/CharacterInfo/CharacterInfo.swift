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

public final class CharacterInfo {

    static let characterCacheProvider = CharacterCacheProvider()

    private let localServer: LocalServer

    public init(localServer: LocalServer = LocalServer()) {
        self.localServer = localServer
    }

    public func run(handler: Handler? = Handler(rawValue: Lambda.handler)) throws {
        switch handler {
        case .read:
            Lambda.run(CharacterReadLambdaHandler.init)

        case .list:
            Lambda.run(CharacterListLambdaHandler.init)

        case .create:
            Lambda.run(CharacterCreateLambdaHandler.init)

        case .update, .delete, .none:
            throw APIError.handlerUnknown
        }
    }

}
