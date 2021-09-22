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
    public let emailService: EmailService

    init(
        feedbackRepository: FeedbackRepository,
        emailService: EmailService
    ) {
        self.feedbackRepository = feedbackRepository
        self.emailService = emailService
    }
    
    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        feedbackRepository.create(feedback, in: table)
            .flatMap { feedback in
                let data = try? JSONEncoder().encode(feedback)
                
                return self.emailService.send(
                    toAddresses: [.email],
                    bodyText: data?.prettyJson ?? feedback.description,
                    subject: .feedbackSubject,
                    source: .email
                )
                    .map { _ in feedback }
            }
    }

}
