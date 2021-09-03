//
//  Feedback+Domain.Feedback.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/09/2021.
//

import struct Domain.Feedback
import Foundation

extension Feedback {
    
    init(from feedback: Domain.Feedback) {
        self.init(
            message: feedback.message,
            email: feedback.email
        )
    }
    
}
