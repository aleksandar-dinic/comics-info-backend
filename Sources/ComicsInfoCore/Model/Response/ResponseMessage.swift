//
//  ResponseMessage.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct ResponseMessage: Codable {

    let message: String

    public init(_ message: String) {
        self.message = message
    }
    
    public init(for error: Error) {
        message = error.localizedDescription
    }

}
