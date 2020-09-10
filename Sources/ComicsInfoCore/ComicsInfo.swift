//
//  ComicsInfo.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 31/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation

public final class ComicsInfo {

    static let characterCacheProvider = CharacterCacheProvider()

    static var isMocked: Bool {
        ProcessInfo.processInfo.environment["LOCAL_LAMBDA_SERVER_ENABLED"] == "true"
    }

    public init() {

    }

    public func run() {
        Lambda.run(ComicsInfoLambdaHandler.init)
    }

}
