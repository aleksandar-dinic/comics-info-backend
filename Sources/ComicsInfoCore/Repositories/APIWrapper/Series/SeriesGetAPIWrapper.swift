//
//  SeriesGetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 03/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct SeriesGetAPIWrapper: GetAPIWrapper {
    
    typealias Item = Series
    
    let repositoryAPIService: RepositoryAPIService

}
