//
//  CreateMyComicRequest.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

struct CreateMyComicRequest {
    
    let data: Data
    let seriesID: String
    let token: String
    let table: String
    let eventLoop: EventLoop
    
}

extension CreateMyComicRequest {
    
    init(
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        do {
            data = try request.encodeBody()
            seriesID = try request.getSeriesIDFromQueryParameters()
            token = try request.getTokenFromHeaders()
        } catch {
            throw error
        }
        
        table = String.tableName(for: environment)
        self.eventLoop = eventLoop
    }
    
}
