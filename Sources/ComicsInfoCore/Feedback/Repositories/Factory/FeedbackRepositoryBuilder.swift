//
//  FeedbackRepositoryBuilder.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct SotoDynamoDB.DynamoDB
import struct SotoSES.SES
import Foundation
import NIO

public protocol FeedbackRepositoryBuilder  {

    var eventLoop: EventLoop { get }
    var isLocalServer: Bool { get }
    
    func makeRepository() -> FeedbackRepository

}

extension FeedbackRepositoryBuilder {
    
    public func makeRepository() -> FeedbackRepository {
        FeedbackRepositoryFactory(dbService: makeDBService())
            .make()
    }

    private func makeDBService() -> FeedbackDBService {
        SotoDynamoDB.DynamoDB(eventLoop: eventLoop)
    }
    
    func makeEmailService() -> EmailService {
        SotoSES.SES(eventLoop: eventLoop)
    }

}

