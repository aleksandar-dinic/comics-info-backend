//
//  SeriesCreateAPIWrapper.swift
//  SeriesInfo
//
//  Created by Aleksandar Dinic on 28/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesCreateAPIWrapper: CreateAPIWrapper {

    typealias Item = Series

    let repositoryAPIService: CreateRepositoryAPIService
    
}
