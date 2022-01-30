//
//  Handler.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public enum Handler: Equatable {
    
    case character(operation: CRUDOperation)
    case series(operation: CRUDOperation)
    case comic(operation: CRUDOperation)
    case feedback(operation: CRUDOperation)
    case myCharacters(operation: CRUDOperation)
    case myComics(operation: CRUDOperation)
    
    public init?(for handler: String) {
        let handlers = handler.split(separator: ".").compactMap { String($0) }
        guard
            handlers.count == 2,
            let operation = CRUDOperation(rawValue: handlers[1])
        else { return nil }
        
        switch handlers[0] {
        case "character":
            self = .character(operation: operation)
        case "series":
            self = .series(operation: operation)
        case "comic":
            self = .comic(operation: operation)
        case "feedback":
            self = .feedback(operation: operation)
        case "my-characters":
            self = .myCharacters(operation: operation)
        case "my-comics":
            self = .myComics(operation: operation)
        default:
            return nil
        }
    }
    
}
