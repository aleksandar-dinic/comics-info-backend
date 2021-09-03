//
//  Domain.Feedback+Feedback.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/09/2021.
//

import struct Domain.Feedback
import Foundation

extension Domain.Feedback {
    
    init(from feedback: Feedback) {
        self.init(
            message: feedback.message,
            email: feedback.email
        )
    }
    
}
