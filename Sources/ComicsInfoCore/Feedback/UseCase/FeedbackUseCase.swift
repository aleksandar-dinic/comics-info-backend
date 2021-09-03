//
//  FeedbackUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class FeedbackUseCase {
    
    public let feedbackRepository: FeedbackRepository

    init(feedbackRepository: FeedbackRepository) {
        self.feedbackRepository = feedbackRepository
    }
    
    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        feedbackRepository.create(feedback, in: table)
    }

}
