//
//  ListResponseWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 24/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol ListResponseWrapper: ErrorResponseWrapper {

    func handleList(
        on eventLoop: EventLoop,
        request: Request,
        environment: String?
    ) -> EventLoopFuture<Response>

}

extension ListResponseWrapper {
    
    func getFields(from queryParams: [String: String]?) -> Set<String>? {
        guard let fields = queryParams?["fields"]?.split(separator: ",").compactMap({ String($0) }) else {
            return nil
        }
        
        return Set(fields)
    }
    
}
