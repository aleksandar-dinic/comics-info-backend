//
//  FeedbackDBService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import class NIO.EventLoopFuture
import Foundation

protocol FeedbackDBService {
    
    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback>

}
