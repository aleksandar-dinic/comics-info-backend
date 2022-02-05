//
//  ReadMyComicRequest.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

struct ReadMyComicRequest {
    
    let comicID: String
    let seriesID: String
    let token: String
    let table: String
    let eventLoop: EventLoop
    
}

extension ReadMyComicRequest {
    
    init(
        comicID: String,
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        self.comicID = comicID
        
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
