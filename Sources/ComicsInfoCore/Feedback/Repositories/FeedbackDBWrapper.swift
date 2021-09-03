//
//  FeedbackDBWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct FeedbackDBWrapper {
    
    var dbService: FeedbackDBService
    
    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        dbService.create(feedback, in: table)
            .flatMapErrorThrowing {
                throw $0.mapToComicInfoError(itemType: Feedback.self)
            }
    }
    
}
