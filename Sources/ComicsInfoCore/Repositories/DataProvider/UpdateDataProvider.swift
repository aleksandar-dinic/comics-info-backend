//
//  UpdateDataProvider.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

struct UpdateDataProvider<APIWrapper: UpdateRepositoryAPIWrapper> {

    let repositoryAPIWrapper: APIWrapper

    func update(_ item: APIWrapper.Item, in table: String) -> EventLoopFuture<Void> {
        repositoryAPIWrapper.update(item, in: table)
    }

}
