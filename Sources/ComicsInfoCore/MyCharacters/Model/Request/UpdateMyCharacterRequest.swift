//
//  UpdateMyCharacterRequest.swift
//  
//
//  Created by Aleksandar Dinic on 1/30/22.
//

import Foundation
import NIO

struct UpdateMyCharacterRequest {
    
    let id: String
    let data: Data
    let token: String
    let table: String
    let eventLoop: EventLoop
    
}

extension UpdateMyCharacterRequest {
    
    init(
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        do {
            id = try request.getIDFromPathParameters()
            data = try request.encodeBody()
            token = try request.getTokenFromHeaders()
            table = String.tableName(for: environment)
            self.eventLoop = eventLoop
        } catch {
            throw error
        }
    }
    
}
