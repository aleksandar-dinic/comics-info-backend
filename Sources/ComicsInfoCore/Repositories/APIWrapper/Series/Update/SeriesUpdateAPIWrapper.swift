//
//  SeriesUpdateAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 06/10/2020.
//  Copyright © 2020 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct SeriesUpdateAPIWrapper: UpdateAPIWrapper {

    typealias Item = Series

    let repositoryAPIService: UpdateRepositoryAPIService

}
