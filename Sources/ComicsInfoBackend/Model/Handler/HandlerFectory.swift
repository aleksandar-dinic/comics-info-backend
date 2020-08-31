//
//  HandlerFectory.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaEvents
import Foundation

struct HandlerFectory {

    private let mocked: Bool

    init(mocked: Bool = ProcessInfo.processInfo.environment["LOCAL_LAMBDA_SERVER_ENABLED"] == "true") {
        self.mocked = mocked
    }

    func makeHandler(forRequest request: APIGateway.V2.Request) -> Handler? {
        guard mocked else {
            return Handler.current
        }

        switch request.context.http.path {
        case let path where path.starts(with: "/characters"):
            return makeCharacterHandler(path: path, method: request.context.http.method)

        default:
            return nil
        }
    }

    private func makeCharacterHandler(path: String, method: HTTPMethod) -> Handler? {
        switch (path, method) {
        case ("/characters", .POST):
            return .characters(.create)

        case (let path, .GET) where path.starts(with: "/characters/"):
            return .characters(.read)

        case (let path, .PUT) where path.starts(with: "/characters/"):
            return .characters(.update)

        case (let path, .DELETE) where path.starts(with: "/characters/"):
            return .characters(.delete)

        case ("/characters", .GET):
            return .characters(.list)

        default:
            return nil
        }
    }

}
