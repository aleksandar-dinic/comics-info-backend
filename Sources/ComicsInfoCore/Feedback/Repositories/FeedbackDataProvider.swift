//
//  FeedbackDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct FeedbackDataProvider {

    let dbWrapper: FeedbackDBWrapper

    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        dbWrapper.create(feedback, in: table)
    }
    
}
