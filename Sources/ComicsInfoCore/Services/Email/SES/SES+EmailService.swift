//
//  SES+EmailService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 22/09/2021.
//

import Foundation
import SotoSES

extension SES: EmailService {

    public func send(
        toAddresses: [String],
        bodyText: String,
        subject: String,
        source: String
    ) -> EventLoopFuture<String> {
        let body = Body(text: Content(data: bodyText))
        let subject = Content(data: subject)
        let request = SendEmailRequest(
            destination: Destination(toAddresses: toAddresses),
            message: Message(body: body, subject: subject),
            source: source
        )
        print("Send email request: \(request)")
        return sendEmail(request)
            .map {
                print("Send email response: \($0)")
                return $0.messageId
            }
            .flatMapErrorThrowing {
                print("Send Email ERROR: \($0)")
                throw $0
            }
    }
    
}
