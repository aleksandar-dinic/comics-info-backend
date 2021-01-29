//
//  ComicCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 05/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct ComicCreateAPIWrapper: CreateAPIWrapper {

    typealias Item = Comic
    
    let repositoryAPIService: CreateRepositoryAPIService

}
