//
//  FeedbackDBWrapperFactory.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/09/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation

protocol FeedbackDBWrapperFactory {

    var dbService: FeedbackDBService { get }
    
    func makeDBService() -> FeedbackDBWrapper
    
}

extension FeedbackDBWrapperFactory {
    
    func makeDBService() -> FeedbackDBWrapper {
        FeedbackDBWrapper(dbService: dbService)
    }

}
