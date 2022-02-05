//
//  CreateFeedbackRequest.swift
//  
//
//  Created by Aleksandar Dinic on 2/5/22.
//

import Foundation
import NIO

struct CreateFeedbackRequest {
    
    let data: Data
    let token: String?
    let table: String
    let eventLoop: EventLoop
    let headers: [String: String]?
    
}

extension CreateFeedbackRequest {
    
    init(
        request: Request,
        environment: String?,
        eventLoop: EventLoop
    ) throws {
        do {
            data = try request.encodeBody()
        } catch {
            throw error
        }
        
        token = try? request.getTokenFromHeaders()
        table = String.tableName(for: environment)
        self.eventLoop = eventLoop
        self.headers = request.headers
    }
    
}
