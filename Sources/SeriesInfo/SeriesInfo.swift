//
//  SeriesInfo.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import ComicsInfoCore
import Foundation
import enum AWSLambdaRuntime.Lambda

public final class SeriesInfo {

    static let seriesInMemoryCache = InMemoryCacheProvider<Series>()

    private let localServer: LocalServer

    public init(localServer: LocalServer = LocalServer()) {
        self.localServer = localServer
    }

    public func run(handler: Handler? = Handler(rawValue: Lambda.handler)) throws {
        switch handler {
        case .read:
            Lambda.run { LambdaHandlerFactory.makeReadLambdaHandler($0) }

        case .list:
            Lambda.run { LambdaHandlerFactory.makeListLambdaHandler($0) }

        case .create:
            Lambda.run { LambdaCreateHandlerFactory.makeHandler($0) }

        case .update:
            Lambda.run { LambdaUpdateHandlerFactory.makeHandler($0) }

        case .delete, .none:
            throw APIError.handlerUnknown
        }
    }

}
