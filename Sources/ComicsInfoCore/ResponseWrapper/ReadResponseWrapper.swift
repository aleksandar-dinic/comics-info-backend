//
//  ReadResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import struct Logging.Logger
import Foundation
import NIO

public protocol ReadResponseWrapper: ErrorResponseWrapper {

    func handleRead(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?,
        logger: Logger?
    ) -> EventLoopFuture<Response>

}

extension ReadResponseWrapper {
    
    func getFields(from queryParams: [String: String]?) -> Set<String>? {
        guard let fields = queryParams?["fields"]?.split(separator: ",").compactMap({ String($0) }) else {
            return nil
        }
        
        return Set(fields)
    }
    
}
