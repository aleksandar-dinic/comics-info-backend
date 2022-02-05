//
//  ListMyComicRequest.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

struct ListMyComicRequest {
    
    let seriesID: String
    let token: String
    let table: String
    let eventLoop: EventLoop
    
}

extension ListMyComicRequest {
    
    init(
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        do {
            seriesID = try request.getSeriesIDFromQueryParameters()
            token = try request.getTokenFromHeaders()
        } catch {
            throw error
        }

        table = String.tableName(for: environment)
        self.eventLoop = eventLoop
    }
    
}
