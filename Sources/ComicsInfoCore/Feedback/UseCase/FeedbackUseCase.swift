//
//  FeedbackUseCase.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import struct Domain.Feedback
import Foundation
import NIO

public final class FeedbackUseCase {
    
    public let feedbackRepository: FeedbackRepository
    public let emailService: EmailService
    public let authService: AuthService

    init(
        feedbackRepository: FeedbackRepository,
        emailService: EmailService,
        authService: AuthService
    ) {
        self.feedbackRepository = feedbackRepository
        self.emailService = emailService
        self.authService = authService
    }
    
    func create(with request: CreateFeedbackRequest) -> EventLoopFuture<Feedback> {
        getUserID(token: request.token, on: request.eventLoop)
            .flatMapThrowing { userID  -> Feedback in
                let item = try JSONDecoder().decode(Domain.Feedback.self, from: request.data)
                return Feedback(from: item, userID: userID, headers: request.headers)
            }
            .flatMap { feedback in
                self.feedbackRepository.create(feedback, in: request.table)
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
    
    private func getUserID(token: String?, on eventLoop: EventLoop) -> EventLoopFuture<String?> {
        guard let token = token else {
            return eventLoop.submit { nil }
        }
        
        return authService.authenticate(token: token, on: eventLoop)
            .map { $0.id }
            .flatMapErrorThrowing { _ in
                return nil
            }
    }

}
