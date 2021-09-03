//
//  FeedbackRepository.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public final class FeedbackRepository {

    private let dataProvider: FeedbackDataProvider

    init(dataProvider: FeedbackDataProvider) {
        self.dataProvider = dataProvider
    }

    func create(_ feedback: Feedback, in table: String) -> EventLoopFuture<Feedback> {
        dataProvider.create(feedback, in: table)
    }

}
