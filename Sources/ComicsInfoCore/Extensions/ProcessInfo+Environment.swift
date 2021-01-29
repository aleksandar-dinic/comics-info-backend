//
//  ProcessInfo+Environment.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public extension ProcessInfo {

    static func isLocalServerEnabled(_ key: String = "LOCAL_LAMBDA_SERVER_ENABLED") -> Bool {
        processInfo.environment[key].flatMap(Bool.init) ?? false
    }

}
