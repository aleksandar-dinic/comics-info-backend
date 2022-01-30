//
//  AuthService.swift
//  AWSLambdaEvents
//
//  Created by Aleksandar Dinic on 20/01/2022.
//

import Foundation
import NIO

public protocol AuthService {
    
    func authenticate(token: String, on eventLoop: EventLoop) -> EventLoopFuture<User>
    
}
