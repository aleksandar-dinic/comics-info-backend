//
//  SES+InitWithEventLoop.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import AsyncHTTPClient
import Foundation
import SotoSES

extension SES {

    init(eventLoop: EventLoop) {
        let httpClient = HTTPClient(
            eventLoopGroupProvider: .shared(eventLoop),
            configuration: HTTPClient.Configuration(timeout: .default)
        )

        let client = AWSClient(httpClientProvider: .shared(httpClient))
        self.init(client: client, region: .getFromEnvironment())
    }

}
