//
//  main.swift
//  ComicsInfoBackend
//
//  Created by Aleksandar Dinic on 26/08/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import AWSLambdaRuntime
import Foundation

Lambda.run(ComicsInfoLamdaHandler.init)
