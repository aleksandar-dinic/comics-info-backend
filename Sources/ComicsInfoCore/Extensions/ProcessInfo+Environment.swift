//
//  ProcessInfo+Environment.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

public extension ProcessInfo {

    static var isLocalServerEnabled: Bool {
        processInfo.environment["LOCAL_LAMBDA_SERVER_ENABLED"].flatMap(Bool.init) ?? false
    }

}
