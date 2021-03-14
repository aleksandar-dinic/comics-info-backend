//
//  ResponseStatus.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 23/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct ResponseStatus: Codable {

    let status: String

    public init(_ status: String) {
        self.status = status
    }
    
    public init(for error: Error) {
        status = error.localizedDescription
    }

}
