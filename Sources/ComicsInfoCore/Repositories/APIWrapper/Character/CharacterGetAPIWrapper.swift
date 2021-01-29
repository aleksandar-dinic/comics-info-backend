//
//  CharacterGetAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 30/09/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation

struct CharacterGetAPIWrapper: GetAPIWrapper {
    
    typealias Item = Character

    let repositoryAPIService: RepositoryAPIService
    
}
