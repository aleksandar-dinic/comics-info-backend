//
//  FeedbackDataProviderFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol FeedbackDataProviderFactory: FeedbackDBWrapperFactory {

    func makeDataProvider() -> FeedbackDataProvider

}

extension FeedbackDataProviderFactory {

    func makeDataProvider() -> FeedbackDataProvider {
        FeedbackDataProvider(dbWrapper: makeDBService())
    }

}

