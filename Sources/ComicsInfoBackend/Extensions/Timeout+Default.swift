//
//  Timeout+Default.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 27/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import Foundation

extension HTTPClient.Configuration.Timeout {

    static var `default`: HTTPClient.Configuration.Timeout {
        HTTPClient.Configuration.Timeout(
            connect: .seconds(30),
            read: .seconds(30)
        )
    }

}
