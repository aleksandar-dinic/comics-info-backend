//
//  CharacterInfo.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 17/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation

public final class CharacterInfo {

    static let characterCacheProvider = CharacterCacheProvider()

    static var isLocalServer: Bool {
        ProcessInfo.processInfo.environment["LOCAL_LAMBDA_SERVER_ENABLED"].flatMap(Bool.init) ?? false
    }

    public init() {

    }

    public func run(handler: Handler? = Lambda.env("_HANDLER").flatMap(Handler.init)) {
        switch handler {
        case .read:
            Lambda.run(CharacterReadLambdaHandler.init)

        case .list:
            Lambda.run(CharacterListLambdaHandler.init)

        case .create, .update, .delete, .none:
            assertionFailure("Please set HANDLER value for the function you want to run")
        }
    }

}
