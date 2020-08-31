//
//  Handler.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 29/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

enum Handler: Equatable {

    case characters(_ action: HandlerAction)
    case series(_ action: HandlerAction)
    case comics(_ action: HandlerAction)

}

extension Handler {

    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        let values = rawValue.split(separator: ".")

        guard
            values.count == 2,
            let action = HandlerAction(rawValue: String(values[1]))
        else {
            return nil
        }

        switch values[0] {
        case "characters":
            self = .characters(action)

        case "series":
            self = .series(action)

        case "comics":
            self = .comics(action)

        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case let .characters(action):
            return "characters.\(action.rawValue)"

        case let .series(action):
            return "series.\(action.rawValue)"

        case let .comics(action):
            return "comics.\(action.rawValue)"
        }
    }

}
