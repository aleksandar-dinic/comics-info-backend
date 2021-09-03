//
//  FeedbackRepositoryFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

public struct FeedbackRepositoryFactory: FeedbackDataProviderFactory {

    let dbService: FeedbackDBService
    
    public func make() -> FeedbackRepository {
        FeedbackRepository(dataProvider: makeDataProvider())
    }

}
