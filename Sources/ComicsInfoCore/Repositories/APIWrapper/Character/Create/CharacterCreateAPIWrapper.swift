//
//  CharacterCreateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 02/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct CharacterCreateAPIWrapper: CreateAPIWrapper  {

    typealias Item = Character
    
    let repositoryAPIService: CreateRepositoryAPIService

}
