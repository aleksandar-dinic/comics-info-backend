//
//  CreateRepositoryAPIService.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 08/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol CreateRepositoryAPIService {

    func create(_ item: DatabasePutItem) -> EventLoopFuture<Void>
    func createAll(_ items: [DatabasePutItem]) -> EventLoopFuture<Void>

}
