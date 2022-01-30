//
//  CreateMyCharacterRequest.swift
//  
//
//  Created by Aleksandar Dinic on 1/30/22.
//

import Foundation
import NIO

struct CreateMyCharacterRequest {
    
    let data: Data
    let token: String
    let table: String
    let eventLoop: EventLoop
    
}

extension CreateMyCharacterRequest {
    
    init(
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        do {
            data = try request.encodeBody()
            token = try request.getTokenFromHeaders()
            table = String.tableName(for: environment)
            self.eventLoop = eventLoop
        } catch {
            throw error
        }
    }
    
}
