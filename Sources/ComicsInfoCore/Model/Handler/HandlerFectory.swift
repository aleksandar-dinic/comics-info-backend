//
//  HandlerFectory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct HandlerFectory {

    private let mocked: Bool

    init(mocked: Bool = ComicsInfo.isMocked) {
        self.mocked = mocked
    }

    func makeHandler(path: String, method: HTTPMethod) -> Handler? {
        guard mocked else {
            return .current
        }

        switch path {
        case let path where path.starts(with: "/characters"):
            return makeCharacterHandler(path: path, method: method)

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
