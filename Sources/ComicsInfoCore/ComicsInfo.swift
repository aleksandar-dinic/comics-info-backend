//
//  ComicsInfo.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 31/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation

public final class ComicsInfo {

    public init() {

    }

    public func run() {
        Lambda.run(ComicsInfoLambdaHandler.init)
    }

}
