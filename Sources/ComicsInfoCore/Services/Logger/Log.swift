//
//  Log.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 14/02/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Logging
import Foundation

public struct Log {
    
    let message: Logger.Message
    let level: Logger.Level
    let metadata: Logger.Metadata?
    let source: String?
    
    init(
        _ message: Logger.Message,
        level: Logger.Level = .info,
        metadata: Logger.Metadata? = nil,
        source: String? = nil
    ) {
        self.level = level
        self.message = message
        self.metadata = metadata
        self.source = source
    }
    
}
