//
//  EmailService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2021.
//

import Foundation
import NIO

public protocol EmailService {
    
    func send(
        toAddresses: [String],
        bodyText: String,
        subject: String,
        source: String
    ) -> EventLoopFuture<String>
    
}
