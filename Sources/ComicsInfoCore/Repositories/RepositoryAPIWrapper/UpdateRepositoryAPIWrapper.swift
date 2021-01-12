//
//  UpdateRepositoryAPIWrapper.swift
//  ComicsInfoCore
//
//  Created by Aleksandar Dinic on 07/01/2021.
//  Copyright © 2021 Aleksandar Dinic. All rights reserved.
//

import Foundation
import NIO

public protocol UpdateRepositoryAPIWrapper {

    associatedtype Item: Codable & Identifiable

    var repositoryAPIService: UpdateRepositoryAPIService { get }

    func update(_ item: Item, in table: String) -> EventLoopFuture<Void>

}
