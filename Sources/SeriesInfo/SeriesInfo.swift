//
//  SeriesInfo.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import ComicsInfoCore
import Foundation

public final class SeriesInfo {

    static let seriesCacheProvider = SeriesCacheProvider()

    private let localServer: LocalServer

    public init(localServer: LocalServer = LocalServer()) {
        self.localServer = localServer
    }

    public func run(handler: Handler? = Handler(rawValue: Lambda.handler)) throws {
        switch handler {
        case .read:
            Lambda.run(SeriesReadLambdaHandler.init)

        case .list:
            Lambda.run(SeriesListLambdaHandler.init)

        case .create:
            Lambda.run(SeriesCreateLambdaHandler.init)

        case .update, .delete, .none:
            throw APIError.handlerUnknown
        }
    }

}

